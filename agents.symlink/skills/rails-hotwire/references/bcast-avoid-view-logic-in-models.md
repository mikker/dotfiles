---
title: Keep Broadcasting Logic Out of Models
impact: MEDIUM-HIGH
impactDescription: "prevents coupling models to view rendering"
tags: bcast, separation-of-concerns, architecture, callbacks
---

## Keep Broadcasting Logic Out of Models

When models contain inline partial rendering in `after_commit` callbacks, they become tightly coupled to the view layer. This makes testing harder (model tests need view fixtures), creates circular dependencies, and breaks when partials change. The declarative `broadcasts_refreshes` macro is acceptable because it only signals a refresh without rendering. For anything more complex, move broadcast logic to controllers or dedicated jobs where view context is appropriate.

### Shared Payloads Must Be Request-Independent

A broadcast payload is shared by its recipients; it is not rendered separately in each recipient's request context. Rendering from a controller does not make its `Current.user` appropriate for everyone, and a background job has no recipient request context. Use explicit locals and do not rely on request-bound helpers or `Current` attributes in shared broadcast partials.

Refresh broadcasts avoid this problem by letting each recipient render their own authenticated page. When granular shared broadcasts are justified, render only content all authorized recipients may see. Small Stimulus behaviors can personalize presentation—formatting UTC timestamps in the browser's timezone, or changing an already-visible player name to “you” using an identifier supplied by the receiving page. Never use client personalization or hiding as authorization; sensitive content needs authorized audience scoping or separately rendered payloads.

**Incorrect (after_create_commit with inline partial rendering in model):**

```ruby
# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  after_create_commit -> {
    # BAD: model is rendering partials and constructing view-layer HTML
    broadcast_append_to(
      [user, :notifications],
      target: "notification_list",
      partial: "notifications/notification",
      locals: { notification: self, show_timestamp: true, compact: false }
    )

    broadcast_update_to(
      [user, :notifications],
      target: "notification_badge",
      html: ApplicationController.render(
        partial: "shared/badge",
        locals: { count: user.unread_notifications_count }
      )
    )
  }
end
```

**Correct (declarative broadcasts_refreshes or broadcasting from controller/job):**

```ruby
# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  # Option 1: Declarative — no view coupling, triggers page morph
  broadcasts_refreshes_to ->(notification) { [notification.user, :notifications] }
end

# Option 2: When granular control is needed, use a job
# app/jobs/notification_broadcast_job.rb
class NotificationBroadcastJob < ApplicationJob
  def perform(notification)
    Turbo::StreamsChannel.broadcast_append_to(
      [notification.user, :notifications],
      target: "notification_list",
      partial: "notifications/notification",
      locals: { notification: notification }
    )
  end
end
```

```ruby
# app/controllers/notifications_controller.rb
class NotificationsController < ApplicationController
  # Option 3: Broadcast from the controller where view context exists
  def mark_read
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read_at: Time.current)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path }
    end
  end
end
```
