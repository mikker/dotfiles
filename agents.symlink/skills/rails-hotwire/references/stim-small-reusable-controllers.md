---
title: Keep Stimulus Controllers Small and Reusable
impact: MEDIUM
impactDescription: prevents controller bloat and enables composition across views
tags: stim, controllers, reusability, composition
---

## Keep Stimulus Controllers Small and Reusable

A Stimulus controller should do one thing well: toggle visibility, copy to clipboard, count characters, manage a dropdown. When a controller grows beyond 50-80 lines, it likely handles multiple responsibilities and should be split. Small controllers can be composed on the same element or nested elements using multiple `data-controller` declarations, mirroring how CSS classes compose styling.

**Incorrect (monolithic controller handling form validation, submission, and UI feedback):**

```js
// app/javascript/controllers/comment_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter", "submit", "preview"]
  static values = { maxLength: { type: Number, default: 500 } }

  validate() {
    const length = this.inputTarget.value.length
    this.counterTarget.textContent = `${this.maxLengthValue - length} remaining`
    this.counterTarget.classList.toggle("text-red-600", length > this.maxLengthValue)
    this.submitTarget.disabled = length === 0 || length > this.maxLengthValue
  }

  preview() {
    this.previewTarget.innerHTML = this.inputTarget.value
    this.previewTarget.classList.remove("hidden")
  }

  submit(event) {
    if (this.inputTarget.value.length > this.maxLengthValue) {
      event.preventDefault()
    }
    this.submitTarget.textContent = "Sending..."
    this.submitTarget.disabled = true
  }
}
```

**Correct (composed small controllers, each with a single responsibility):**

```erb
<%= form_with model: [@project, Comment.new],
    data: { controller: "auto-submit", action: "turbo:submit-start->auto-submit#disable" } do |f| %>
  <div data-controller="character-count" data-character-count-max-value="500">
    <%= f.text_area :body,
        data: {
          character_count_target: "input",
          action: "input->character-count#update"
        } %>
    <span data-character-count-target="counter">500 remaining</span>
  </div>
  <%= f.submit "Post Comment" %>
<% end %>
```

```js
// app/javascript/controllers/character_count_controller.js
// Reusable on ANY text input across the app
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter"]
  static values = { max: { type: Number, default: 280 } }

  connect() {
    this.update()
  }

  update() {
    const remaining = this.maxValue - this.inputTarget.value.length
    this.counterTarget.textContent = `${remaining} remaining`
    this.counterTarget.classList.toggle("text-red-600", remaining < 0)
  }
}
```

```js
// app/javascript/controllers/auto_submit_controller.js
// Reusable on ANY form that needs submit-state management
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  disable() {
    const button = this.element.querySelector("[type='submit']")
    button.disabled = true
    button.dataset.originalText = button.textContent
    button.textContent = "Sending..."
  }
}
```

Reference: [Stimulus Handbook — Origin](https://stimulus.hotwired.dev/handbook/origin)
