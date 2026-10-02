---
title: Prefer Broadcast Refresh Over Granular Stream Updates
impact: HIGH
impactDescription: "simplifies real-time code by 80%, leverages morphing"
tags: bcast, refresh, morphing, simplicity
---

## Prefer Broadcast Refresh Over Granular Stream Updates

Granular stream broadcasts (`broadcast_append_to`, `broadcast_replace_to`, `broadcast_remove_to`) require you to specify the correct target, partial, and action for every mutation type. See also [`morph-vs-streams`](morph-vs-streams.md) for the controller-side perspective. When a single model change affects multiple page sections (a counter, a list, a status badge), you need multiple broadcast calls with synchronized partials. `broadcasts_refreshes` triggers a single page morph that re-renders the current page server-side and patches only the differences, dramatically reducing code and eliminating target-mismatch bugs.

### Default to Refresh; Measure Recipient Fan-Out

Keep refresh broadcasts as the default for broad page updates. They signal invalidation rather than delivering rendered page HTML: each connected recipient fetches and renders its own page, and morphing must be enabled on that page. One broadcast to 1,000 viewers can therefore produce 1,000 page requests. Debouncing reduces broadcast frequency, not the number of recipients per refresh.

If measured subscriber count, change frequency, or page-render cost makes this expensive, opt that interaction into granular streams. A request-independent partial can be rendered once and delivered to many authorized subscribers. This is a justified exception, not an architectural failure. See [`bcast-avoid-view-logic-in-models`](bcast-avoid-view-logic-in-models.md) for safe shared payloads.

**Incorrect (complex broadcast callbacks targeting multiple elements):**

```ruby
# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post

  after_create_commit -> {
    broadcast_append_to [post, :comments],
      target: "comments",
      partial: "comments/comment"

    broadcast_replace_to [post, :comments],
      target: "comments_count",
      html: "<span id='comments_count'>#{post.comments.count}</span>"

    broadcast_replace_to [post, :comments],
      target: "latest_activity",
      partial: "posts/latest_activity",
      locals: { post: post }
  }

  after_destroy_commit -> {
    broadcast_remove_to [post, :comments]

    broadcast_replace_to [post, :comments],
      target: "comments_count",
      html: "<span id='comments_count'>#{post.comments.count}</span>"
  }
end
```

**Correct (single broadcasts_refreshes that morphs the whole page):**

```ruby
# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post

  # One line replaces all the granular broadcast callbacks above.
  # On any create/update/destroy, subscribers get a page refresh
  # that morphs only the changed DOM elements.
  broadcasts_refreshes_to :post
end
```

```erb
<%# app/views/posts/show.html.erb %>
<%= turbo_stream_from @post %>

<h1><%= @post.title %></h1>
<span id="comments_count"><%= @post.comments.count %></span> comments

<div id="comments">
  <%= render @post.comments %>
</div>

<div id="latest_activity">
  <%= render "posts/latest_activity", post: @post %>
</div>

<%# All three sections (count, list, activity) update automatically
    via a single page morph. No stream templates needed. %>
```
