---
title: Configure Turbo Cache for Preview Pages
impact: HIGH
impactDescription: prevents stale data display and flash of old content
tags: drive, cache, preview, temporary
---

## Configure Turbo Cache for Preview Pages

Turbo caches pages for history restoration and temporary previews during application visits. Elements like flash messages, modal overlays, and loading spinners persist in the cache and reappear as stale artifacts. Mark transient elements with `data-turbo-temporary` to strip them before caching, and use a `turbo-cache-control` meta tag to disable caching entirely on pages with sensitive or rapidly-changing data.

For widgets or temporary state that need resetting before the snapshot, use a `turbo:before-cache` action. Continue to destroy third-party instances and release resources in `disconnect()`, but do not rely on disconnect running before the cache snapshot is taken.

**Incorrect (flash messages and modals persist in cache previews):**

```erb
<%# app/views/layouts/application.html.erb %>
<div class="flash-messages">
  <% flash.each do |type, message| %>
    <div class="flash flash-<%= type %>">
      <%= message %>
    </div>
  <% end %>
</div>

<%# Loading spinner shows in cached preview %>
<div id="loading-overlay" class="hidden">
  <div class="spinner">Loading...</div>
</div>
```

**Correct (transient elements removed before caching):**

```erb
<%# app/views/layouts/application.html.erb %>
<%# data-turbo-temporary removes this element before the page is cached %>
<div class="flash-messages" data-turbo-temporary>
  <% flash.each do |type, message| %>
    <div class="flash flash-<%= type %>">
      <%= message %>
    </div>
  <% end %>
</div>

<%# Loading overlays should also be temporary %>
<div id="loading-overlay" class="hidden" data-turbo-temporary>
  <div class="spinner">Loading...</div>
</div>
```

```erb
<%# Emit in the document head through the application's layout/content_for %>
<%# Prevent caching entirely %>
<meta name="turbo-cache-control" content="no-cache">

<%# Alternative: prevent previews but retain history restoration snapshots %>
<meta name="turbo-cache-control" content="no-preview">
```
