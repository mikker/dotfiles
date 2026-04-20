# DHH Ruby Style Resources

Links to source material, documentation, and further reading for mastering DHH's Ruby/Rails style.

## Primary Source Code

### Campfire (Once)
The main codebase this style guide is derived from.

- **Repository**: https://github.com/basecamp/once-campfire
- **Messages Controller**: https://github.com/basecamp/once-campfire/blob/main/app/controllers/messages_controller.rb
- **JavaScript/Stimulus**: https://github.com/basecamp/once-campfire/tree/main/app/javascript
- **Deployment**: Single Docker container with SQLite

### Other 37signals Open Source
- **Solid Queue**: https://github.com/rails/solid_queue - Database-backed Active Job backend
- **Solid Cache**: https://github.com/rails/solid_cache - Database-backed Rails cache
- **Solid Cable**: https://github.com/rails/solid_cable - Database-backed Action Cable adapter
- **Kamal**: https://github.com/basecamp/kamal - Zero-downtime deployment tool
- **Turbo**: https://github.com/hotwired/turbo-rails - Hotwire's SPA-like page accelerator
- **Stimulus**: https://github.com/hotwired/stimulus - Modest JavaScript framework

## Articles & Blog Posts

### Controller Organization
- **How DHH Organizes His Rails Controllers**: https://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/
  - Definitive article on REST-pure controller design
  - Documents the "only 7 actions" philosophy
  - Shows how to create new controllers instead of custom actions

### Testing Philosophy
- **37signals Dev - Pending Tests**: https://dev.37signals.com/pending-tests/
  - How 37signals handles incomplete tests
  - Pragmatic approach to test coverage
- **37signals Dev - All About QA**: https://dev.37signals.com/all-about-qa/
  - QA philosophy at 37signals
  - Balance between automated and manual testing

### Architecture & Deployment
- **Deploy Campfire on Railway**: https://railway.com/deploy/campfire
  - Single-container deployment example
  - SQLite in production patterns

## Official Documentation

### Rails Guides (DHH's Vision)
- **Rails Doctrine**: https://rubyonrails.org/doctrine
  - The philosophical foundation
  - Convention over configuration explained
  - "Optimize for programmer happiness"

### Hotwire
- **Hotwire**: https://hotwired.dev/
  - Official Hotwire documentation
  - Turbo Drive, Frames, and Streams
- **Turbo Handbook**: https://turbo.hotwired.dev/handbook/introduction
- **Stimulus Handbook**: https://stimulus.hotwired.dev/handbook/introduction

### Current Attributes
- **Rails API - CurrentAttributes**: https://api.rubyonrails.org/classes/ActiveSupport/CurrentAttributes.html
  - Official documentation for the Current pattern
  - Thread-isolated attribute singleton

## Videos & Talks

### DHH Keynotes
- **RailsConf Keynotes**: Search YouTube for "DHH RailsConf"
  - Annual state of Rails addresses
  - Philosophy and direction discussions

### Hotwire Tutorials
- **Hotwire Demo by DHH**: Original demo showing the approach
- **GoRails Hotwire Series**: Practical implementation tutorials

## Books

### By DHH & 37signals
- **Getting Real**: https://basecamp.com/gettingreal
  - Product development philosophy
  - Less is more approach
- **Remote**: Working remotely philosophy
- **It Doesn't Have to Be Crazy at Work**: Calm company culture

### Rails Books
- **Agile Web Development with Rails**: The original Rails book
- **The Rails Way**: Comprehensive Rails patterns

## Gems & Tools Used

### Core Stack
```ruby
# Gemfile patterns from Campfire
gem "rails", "~> 8.0"
gem "sqlite3"
gem "propshaft"        # Asset pipeline
gem "importmap-rails"  # JavaScript imports
gem "turbo-rails"      # Hotwire Turbo
gem "stimulus-rails"   # Hotwire Stimulus
gem "solid_queue"      # Job backend
gem "solid_cache"      # Cache backend
gem "solid_cable"      # WebSocket backend
gem "kamal"            # Deployment
gem "thruster"         # HTTP/2 proxy
gem "image_processing" # Active Storage variants
```

### Development
```ruby
group :development do
  gem "web-console"
  gem "rubocop-rails-omakase"  # 37signals style rules
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
```

## RuboCop Configuration

37signals publishes their RuboCop rules:
- **rubocop-rails-omakase**: https://github.com/rails/rubocop-rails-omakase
  - Official Rails/37signals style rules
  - Use this for consistent style enforcement

```yaml
# .rubocop.yml
inherit_gem:
  rubocop-rails-omakase: rubocop.yml

# Project-specific overrides if needed
```

## Community Resources

### Forums & Discussion
- **Ruby on Rails Discourse**: https://discuss.rubyonrails.org/
- **Reddit r/rails**: https://reddit.com/r/rails

### Podcasts
- **Remote Ruby**: Ruby/Rails discussions
- **Ruby Rogues**: Long-running Ruby podcast
- **The Bike Shed**: Thoughtbot's development podcast

## Key Philosophy Documents

### The Rails Doctrine Pillars
1. Optimize for programmer happiness
2. Convention over Configuration
3. The menu is omakase
4. No one paradigm
5. Exalt beautiful code
6. Provide sharp knives
7. Value integrated systems
8. Progress over stability
9. Push up a big tent

### DHH Quotes to Remember

> "The vast majority of Rails controllers can use the same seven actions."

> "If you're adding a custom action, you're probably missing a controller."

> "Clear code is better than clever code."

> "The test file should be a love letter to the code."

> "SQLite is enough for most applications."

## Version History

This style guide is based on:
- Campfire source code (2024)
- Rails 8.0 conventions
- Ruby 3.3 syntax preferences
- Hotwire 2.0 patterns

Last updated: 2024
