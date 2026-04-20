# Nitro Kit Component Style Guide

Use this guide when building or customizing UI components in your app. It summarizes Nitro Kit conventions for Phlex components, Tailwind styling, helpers, Stimulus, and form layout defaults.

## Principles

- Keep components modest, generic, and composable.
- Prefer Phlex rendering, Tailwind utilities, and Rails-native APIs.
- Use minimal JavaScript, only when interaction needs it.
- Make state visible in markup (`data-*`, `aria-*`) so CSS can respond.
- Validate input early and fail loudly for unknown variants or sizes.

## Internal file layout and naming

- Component class: `app/components/nitro_kit/<component>.rb`
- Helper: `app/helpers/nitro_kit/<component>_helper.rb`
- Stimulus controller: `app/javascript/controllers/nk/<component>_controller.js`
- Component schema: `lib/nitro_kit.rb` (update `NitroKit::SCHEMA`)
- Examples: `test/dummy/app/views/tests/examples/<component>.html.erb`
- Tests: `test/integration/<component>_test.rb`

For custom components and easier upgrades, avoid adding your own components under `app/components/nitro_kit`. Treat this as vendor-style code and keep your work elsewhere while following the same patterns.

## Custom components (recommended)

Put app-specific components in a separate namespace, e.g. `app/components/ui`.

If you want `UI::` instead of `U_I::`, add an inflection so Rails autoloading maps it correctly.

```ruby
# config/initializers/inflections.rb
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "UI"
end
```

You can still subclass `NitroKit::Component` and reuse helpers, but keep your components outside `nitro_kit` for upgrade safety.

## Component anatomy

Use the same shape across components: initializer, `view_template`, private class helpers, and `attr_reader` for public API.

```ruby
# frozen_string_literal: true

module NitroKit
  class Button < Component
    VARIANTS = %i[default primary destructive ghost]

    def initialize(text = nil, variant: :default, size: :md, **attrs)
      @text = text
      @variant = variant
      @size = size

      super(attrs, class: [base_class, variant_class, size_class])
    end

    attr_reader :text, :variant, :size

    def view_template(&block)
      button(type: :button, **attrs) do
        text_or_block(text, &block)
      end
    end

    private

    def base_class
      "inline-flex items-center rounded-md"
    end

    def variant_class
      case variant
      when :default then "bg-background text-foreground"
      when :primary then "bg-primary text-primary-foreground"
      else raise ArgumentError, "Unknown variant `#{variant}'"
      end
    end

    def size_class
      case size
      when :sm then "h-7 px-2.5 text-sm"
      when :md then "h-10 px-4 text-base"
      else raise ArgumentError, "Unknown size `#{size}'"
      end
    end
  end
end
```

## Attribute merging and class composition

`NitroKit::Component` merges attributes for you. Use it instead of manual string concatenation.

```ruby
super(attrs, class: [base_class, variant_class])

# Inside builder methods
mattr(attrs, class: "text-muted-content", data: { slot: "description" })
```

What happens under the hood:

- `class` values are merged using Tailwind Merge.
- `data` hashes are deep-merged.
- `data: { controller: ... }` and `data: { action: ... }` are concatenated.

## Builder methods and slots

Block-style components i.e. `table { |t| t.tr { ... } }`

Builder methods must wrap output in `builder do` so they work in helpers and components.

```ruby
def title(text = nil, **attrs, &block)
  builder do
    h2(**mattr(attrs, class: "text-lg font-semibold")) do
      text_or_block(text, &block)
    end
  end
end
```

Do not use `builder_method`. It is deprecated. Use the `builder do` pattern instead.

Use `data-slot` for internal parts that need styling or selection.

```ruby
div(**mattr(attrs, data: { slot: "description" }, class: description_class))
```

## Text or block APIs

Most components accept either text or a block. Use `text_or_block` to support both.

```ruby
text_or_block(text, &block)
```

If you need safe HTML, pass `ActiveSupport::SafeBuffer` and `text_or_block` will call `plain` for you.

## Accessibility and state

Make state explicit in the DOM and reflect it in CSS.

- Use `role`, `aria-expanded`, `aria-hidden`, `aria-selected`, `aria-current`, and `aria-checked`.
- Toggle state with `data-state` or `aria-*` and style with Tailwind selectors.

Examples from existing components:

- Dropdown: `aria-expanded`, `aria-hidden`
- Tabs: `aria-selected`, `aria-hidden`
- Switch: `role="switch"`, `aria-checked`
- Toast: `data-state="open" | "closed"`

## Stimulus controller naming

Controllers in NitroKit core are `nk--<component>` and map cleanly to data keys.

```ruby
data: {
  controller: "nk--dropdown",
  nk__dropdown_target: "trigger",
  nk__dropdown_placement_value: placement
}
```

Controller conventions:

- `static targets` and `static values` are the default pattern.
- Clean up listeners in `disconnect`.
- If using floating-ui, update positions on open and dispose on close.

## Tailwind + theme tokens

Use the theme tokens from `app/assets/tailwind/application.css`.

- `bg-background`, `text-foreground`, `border-border`, `ring-ring`, `text-muted-content`.
- Prefer arrays of classes for readability.
- Style state using `data-*` and `aria-*` selectors instead of custom CSS.

Premium components show two extra patterns worth copying when needed:

- Container queries with `@container` / `@min` / `@max` (e.g., Dropzone, Sidebar)
- CSS custom props for layout spacing (e.g., Sidebar, Card)

## Helpers and variants

Every internal component should have a helper and optionally variant helpers. Custom components can copy this pattern but it's not a requirement.

```ruby
module NitroKit
  module ButtonHelper
    include Variants

    def nk_button(text = nil, **attrs, &block)
      render(NitroKit::Button.from_template(text, **attrs), &block)
    end

    automatic_variants(Button::VARIANTS, :nk_button)
  end
end
```

## Forms

Use `NitroKit::FormBuilder` and the `nk_form_for` / `nk_form_with` helpers.

- `Field` is the form wrapper that handles label, description, errors, and control.
- `data-slot` is used for internal styling (`label`, `description`, `control`, `error`).
- Strong default: wrap related fields in `fieldset` and `group` for consistent spacing and layout. Only omit if you intentionally want a custom layout.

```erb
<%= nk_form_for @user do |f| %>
  <%= f.fieldset legend: "Profile", description: "Public info" do %>
    <%= f.group do %>
      <%= f.field :name %>
      <%= f.field :email, as: :email, description: "We only email receipts." %>
    <% end %>
  <% end %>
<% end %>
```

## Premium components

Premium components are available separately. The current catalog and install instructions live on nitrokit.dev, which is the source of truth.

Once installed, premium components behave like standard Nitro Kit components. Prefer wrapping or composing them in your own `UI::` components if you need custom behavior, to keep upgrades easy.

Patterns worth noting:

- Premium components still inherit from `NitroKit::Component` and use `mattr`.
- Use `register_output_helper` when calling view helpers (`nk_button`, `file_field_tag`, `content_for`).
- `DetailsTable` still uses the deprecated `builder_method` pattern. Avoid that in new components.

## Do and do not examples

```ruby
# Do: builder wrapper and text_or_block

def description(text = nil, **attrs, &block)
  builder do
    div(**mattr(attrs, class: "text-sm text-muted-content")) do
      text_or_block(text, &block)
    end
  end
end

# Do: use Tailwind Merge via super / mattr
super(attrs, class: [base_class, size_class])

# Do: validate variant and size
raise ArgumentError, "Unknown variant `#{variant}'"
```

```ruby
# Do not: skip builder for builder methods
# def title(text = nil, **attrs)
#   h2(**attrs) { text }
# end

# Do not: manually concatenate classes
# super(attrs.merge(class: "#{base_class} #{attrs[:class]}"))

# Do not: silently ignore unknown variants
# when :default then ...
# else nil
```

## Component checklist

Core Nitro Kit (internal):

- Add component class under `app/components/nitro_kit/`.
- Add helper under `app/helpers/nitro_kit/`.
- Add JS controller under `app/javascript/controllers/nk/` if needed.
- Update `NitroKit::SCHEMA` in `lib/nitro_kit.rb`.
- Add example view under `test/dummy/app/views/tests/examples/`.
- Add integration test under `test/integration/`.

Custom app components (recommended):

- Create under `app/components/ui/` (or your own namespace).
- Subclass `NitroKit::Component` if you want `mattr`, class merging, and `text_or_block`.
- Add a helper only if you want a `ui_*` (or similar) template API.
