---
title: Handle Frame Breakout for Redirects
impact: HIGH
impactDescription: prevents content-missing failures on auth redirects
tags: frame, breakout, redirect, authentication
---

## Handle Frame Breakout for Redirects

When a Turbo Frame request receives a response that does not contain a matching `<turbo-frame>` element, Turbo emits `turbo:frame-missing`; by default it displays “Content missing” and throws an exception. This commonly happens when an authenticated frame request gets redirected to a login page, or when a frame action redirects to an unrelated page. Add a `turbo-visit-control` meta tag on pages that must always break out of frames. Use `target="_top"` only when links and forms in the frame should normally navigate the whole page; it does not repair a missing frame in a `src` response.

**Incorrect (login redirect producing content missing inside a frame):**

```erb
<%# app/views/projects/show.html.erb %>
<%# When session expires, this frame request redirects to /login
    but the login page has no matching frame — user sees Content missing %>
<%= turbo_frame_tag "project_comments",
    src: project_comments_path(@project) do %>
  <p>Loading comments...</p>
<% end %>
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless current_user
      # This redirect breaks frame requests — login page
      # won't have a matching turbo-frame tag
      redirect_to login_path
    end
  end
end
```

**Correct (proper breakout handling for auth and cross-page redirects):**

```erb
<%# app/views/sessions/new.html.erb (login page) %>
<%# Force full-page reload when login page is loaded inside a frame %>
<head>
  <meta name="turbo-visit-control" content="reload">
</head>

<h1>Sign in</h1>
<%= form_with url: session_path do |f| %>
  <%= f.email_field :email %>
  <%= f.password_field :password %>
  <%= f.submit "Sign in" %>
<% end %>
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless current_user
      # Redirect normally — the meta tag on the login page handles breakout.
      # Turbo fetches the redirect target, sees turbo-visit-control="reload",
      # and triggers a full-page navigation automatically.
      redirect_to login_path
    end
  end
end
```

```erb
<%# Whole-page navigation for links and forms inside this frame %>
<%# The src response must still contain the matching frame %>
<%= turbo_frame_tag "project_comments",
    src: project_comments_path(@project),
    target: "_top" do %>
  <p>Loading comments...</p>
<% end %>
```

**Caveat:** `turbo-visit-control="reload"` causes two GET requests — the first is the frame fetch that discovers the meta tag, and the second is the full-page reload Turbo triggers. Flash messages set during the redirect can be consumed by the first request. If flash preservation matters, keep the needed flash in the redirect target's controller when `turbo_frame_request?` is true, and test the complete navigation. Turbo has no built-in `redirect` stream action; do not emit one unless the application explicitly registers it.

For other missing-frame responses, intercept `turbo:frame-missing`, report the response URL/status and expected frame ID to the application's error tracker, and provide a fallback or appropriate full-page visit. Recovery is not a substitute for fixing a missing wrapper in a normal response. See [`drive-error-recovery`](drive-error-recovery.md).
