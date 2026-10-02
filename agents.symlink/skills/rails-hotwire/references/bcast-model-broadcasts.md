---
title: Use broadcasts_refreshes for Simple Model Updates
impact: HIGH
impactDescription: "zero-config real-time updates with single line"
tags: bcast, broadcasts-refreshes, real-time, model
---

## Use broadcasts_refreshes for Simple Model Updates

For straightforward real-time updates where all subscribers should see the latest state of a page, `broadcasts_refreshes` provides maximum value with minimal code. A single declaration in the model triggers a page morph for every subscribed client after create, update, or destroy. This eliminates the need to manually wire Action Cable channels, write JavaScript handlers, or maintain stream templates for each mutation type.

Use declarative broadcasts for ordinary lifecycle-driven updates. If delivery belongs to a specific business operation rather than every save, let that operation explicitly trigger a broadcast instead. Bulk imports should suppress automatic broadcasts and deliver one update after successful completion; see [`bcast-debounce-n1`](bcast-debounce-n1.md). Do not abandon callbacks preemptively, but do not make imports or exceptional workflows inherit unintended side effects.

Refresh messages cause recipients to fetch their current page. Enable page morphing with `<meta name="turbo-refresh-method" content="morph">`; the model macro alone does not enable it. For recipient fan-out costs, see [`bcast-refresh-over-replace`](bcast-refresh-over-replace.md).

**Incorrect (manually wiring ActionCable channels and JavaScript handlers):**

```ruby
# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :project

  after_create_commit -> { broadcast_append_to project, target: "tasks" }
  after_update_commit -> { broadcast_replace_to project }
  after_destroy_commit -> { broadcast_remove_to project }
end
```

```javascript
// app/javascript/channels/project_channel.js
import consumer from "./consumer"

// BAD: manual channel subscription duplicating what Turbo handles
consumer.subscriptions.create(
  { channel: "ProjectChannel", project_id: projectId },
  {
    received(data) {
      const tasksContainer = document.getElementById("tasks");
      tasksContainer.innerHTML = data.html;
    },
  }
);
```

**Correct (broadcasts_refreshes in model + turbo_stream_from in view):**

```ruby
# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :project

  broadcasts_refreshes_to :project
end
```

```erb
<%# app/views/projects/show.html.erb %>

<%# Subscribe to the project's broadcast stream %>
<%= turbo_stream_from @project %>

<h1><%= @project.name %></h1>

<div id="tasks">
  <%= render @project.tasks %>
</div>

<%# That's it. Any Task create/update/destroy triggers a page morph
    for all users viewing this project. No JavaScript required. %>
```
