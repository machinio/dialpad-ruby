# 🚧 Currently under construction 🚧

# Dialpad Ruby Gem

A Ruby client for the Dialpad API that provides easy access to webhooks, subscriptions, contacts, and calls with full CRUD operations and comprehensive validation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dialpad'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dialpad

## Configuration

The gem can be configured in two ways:

### 1. Environment Variables (Recommended)

Set the following environment variables:

```bash
export DIALPAD_API_BASE_URL="https://dialpad.com/api/v2"
export DIALPAD_API_TOKEN="your_api_token_here"
```

### 2. Programmatic Configuration

```ruby
require 'dialpad'

Dialpad.configure do |config|
  config.base_url = "https://dialpad.com/api/v2"
  config.token = "your_api_token_here"
end
```

## Usage

### Webhooks

```ruby
# List all webhooks
webhooks = Dialpad::Webhook.list

# Retrieve a specific webhook
webhook = Dialpad::Webhook.retrieve(webhook_id)

# Create a new webhook (requires hook_url)
new_webhook = Dialpad::Webhook.create({
  hook_url: "https://your-app.com/webhooks/dialpad"
})

# Update a webhook
updated_webhook = Dialpad::Webhook.update(webhook_id, {
  hook_url: "https://your-app.com/webhooks/dialpad-updated"
})

# Delete a webhook
Dialpad::Webhook.destroy(webhook_id)
```

### Event Subscriptions

The gem provides separate classes for different event types:

#### Call Event Subscriptions

```ruby
# List call event subscriptions
subscriptions = Dialpad::Subscriptions::CallEvent.list

# Retrieve a specific call event subscription
subscription = Dialpad::Subscriptions::CallEvent.retrieve(subscription_id)

# Create a new call event subscription (requires webhook_id)
new_subscription = Dialpad::Subscriptions::CallEvent.create({
  webhook_id: webhook_id,
  call_states: ["completed", "started"]
})

# Update a call event subscription
updated_subscription = Dialpad::Subscriptions::CallEvent.update(subscription_id, {
  call_states: ["completed", "started", "ended"]
})

# Delete a call event subscription
Dialpad::Subscriptions::CallEvent.destroy(subscription_id)
```

#### Contact Event Subscriptions

```ruby
# List contact event subscriptions
subscriptions = Dialpad::Subscriptions::ContactEvent.list

# Retrieve a specific contact event subscription
subscription = Dialpad::Subscriptions::ContactEvent.retrieve(subscription_id)

# Create a new contact event subscription (requires webhook_id)
new_subscription = Dialpad::Subscriptions::ContactEvent.create({
  webhook_id: webhook_id,
  contact_events: ["created", "updated"]
})

# Update a contact event subscription
updated_subscription = Dialpad::Subscriptions::ContactEvent.update(subscription_id, {
  contact_events: ["created", "updated", "deleted"]
})

# Delete a contact event subscription
Dialpad::Subscriptions::ContactEvent.destroy(subscription_id)
```

### Contacts

```ruby
# List all contacts
contacts = Dialpad::Contact.list

# Retrieve a specific contact
contact = Dialpad::Contact.retrieve(contact_id)

# Create a new contact (requires first_name and last_name)
new_contact = Dialpad::Contact.create({
  first_name: "John",
  last_name: "Doe",
  emails: ["john.doe@example.com"],
  phones: ["+1234567890"]
})

# Create or update contact with UID
contact = Dialpad::Contact.create_or_update({
  first_name: "John",
  last_name: "Doe",
  uid: "unique_identifier"
})

# Update a contact
updated_contact = Dialpad::Contact.update(contact_id, {
  first_name: "Jane",
  emails: ["jane.doe@example.com"]
})

# Delete a contact
Dialpad::Contact.destroy(contact_id)
```

### Calls

```ruby
# List all calls
calls = Dialpad::Call.list

# Retrieve a specific call
call = Dialpad::Call.retrieve(call_id)

# Access call attributes
puts call.direction        # => "inbound"
puts call.state           # => "completed"
puts call.date_started    # => 1704110400
puts call.duration        # => 120
puts call.external_number # => "+1234567890"
```

## Response Format

### Standard Objects
Most API responses are returned as structured objects with dot notation access:

```ruby
webhook = Dialpad::Webhook.retrieve(1)
puts webhook.id          # => 1
puts webhook.hook_url    # => "https://example.com/webhook"
```

## Validation

The gem includes comprehensive validation for required attributes:

### Required Attributes
- **Webhooks**: `hook_url` for create operations
- **Subscriptions**: `webhook_id` for create operations
- **Contacts**: `first_name` and `last_name` for create operations
- **All Resources**: `id` for retrieve, update, destroy operations

### Validation Examples

```ruby
# This will raise Dialpad::Webhook::RequiredAttributeError
Dialpad::Webhook.create({})

# This will raise Dialpad::Contact::RequiredAttributeError
Dialpad::Contact.create({ email: "test@example.com" })

# This will raise Dialpad::Call::RequiredAttributeError
Dialpad::Call.retrieve(nil)
```

## Error Handling

The gem raises appropriate exceptions for different error conditions:

```ruby
begin
  webhook = Dialpad::Webhook.retrieve(999)
rescue Dialpad::APIError => e
  puts "API Error: #{e.message}"
rescue Dialpad::ConfigurationError => e
  puts "Configuration Error: #{e.message}"
rescue Dialpad::Webhook::RequiredAttributeError => e
  puts "Validation Error: #{e.message}"
end
```

### Exception Types
- `Dialpad::APIError` - HTTP/API related errors
- `Dialpad::ConfigurationError` - Missing configuration
- `Dialpad::Webhook::RequiredAttributeError` - Webhook validation errors
- `Dialpad::Subscriptions::CallEvent::RequiredAttributeError` - Call event validation errors
- `Dialpad::Subscriptions::ContactEvent::RequiredAttributeError` - Contact event validation errors
- `Dialpad::Contact::RequiredAttributeError` - Contact validation errors
- `Dialpad::Call::RequiredAttributeError` - Call validation errors

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/dialpad-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/maddale/dialpad-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
