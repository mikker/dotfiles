---
title: Handle Turbo Navigation and Fetch Errors Gracefully
impact: HIGH
impactDescription: prevents blank screens and silent failures on server errors
tags: drive, error-handling, resilience, events
---

## Handle Turbo Navigation and Fetch Errors Gracefully

Distinguish HTTP error responses, network failures, and missing-frame responses. `turbo:fetch-request-error` covers network errors in form/frame fetches, not ordinary HTTP 404/500 responses. A response without the expected frame emits `turbo:frame-missing`; by default Turbo displays “Content missing” and throws an exception. `turbo:frame-render` is a render lifecycle event, not an error event. Use the appropriate event to provide recovery without hiding actionable bugs.

Report missing-frame response URLs/statuses and expected frame IDs to the application's error tracker before showing a fallback. A missing wrapper in a normal response is a bug to fix; expired sessions and unavailable records need intentional recovery. Keep known login breakout handling in [`frame-break-out`](frame-break-out.md).

**Incorrect (no intentional recovery for failed frame requests):**

```erb
<%# app/views/projects/show.html.erb %>
<%# If this endpoint returns HTML without the frame, Turbo reports Content missing %>
<%= turbo_frame_tag "project_comments",
    src: project_comments_path(@project),
    loading: :lazy do %>
  <p>Loading comments...</p>
<% end %>

<%# No application-specific recovery or error reporting is configured %>
```

**Correct (event listeners for error recovery and user feedback):**

```js
// app/javascript/turbo_error_handler.js
// Handle network errors in form/frame fetches
document.addEventListener("turbo:fetch-request-error", (event) => {
  event.preventDefault()
  const message = navigator.onLine
    ? "Something went wrong. Please try again."
    : "You appear to be offline. Check your connection."
  showFlash(message, "error")
})

// Handle missing frame content (frame response doesn't contain matching frame)
document.addEventListener("turbo:frame-missing", (event) => {
  event.preventDefault()
  const frame = event.target
  // Wire this to the application's error tracker; do not silently swallow it.
  console.error("Missing Turbo Frame", {
    frameId: frame.id,
    url: event.detail.response.url,
    status: event.detail.response.status
  })
  frame.innerHTML = `
    <div class="frame-error" role="alert">
      <p>This content could not be loaded.</p>
      <button onclick="this.closest('turbo-frame').reload()">Retry</button>
    </div>
  `
})

function showFlash(message, level) {
  const flash = document.createElement("div")
  flash.className = `flash flash-${level}`
  flash.setAttribute("role", "alert")
  flash.textContent = message
  document.querySelector(".flash-messages")?.appendChild(flash)
  setTimeout(() => flash.remove(), 5000)
}
```

```erb
<%# app/views/layouts/application.html.erb %>
<%= javascript_importmap_tags %>

<div class="flash-messages" data-turbo-temporary>
  <%# Flash container for both server and client-side messages %>
</div>

<%= yield %>
```

**When NOT to use this pattern:**
- For API-only endpoints that don't serve HTML — use standard HTTP error handling
- In development mode where you want to see full error pages for debugging

Reference: [Turbo Reference — Events](https://turbo.hotwired.dev/reference/events)
