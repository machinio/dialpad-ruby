#!/usr/bin/env ruby

require_relative '../lib/dialpad'

# Configure the gem (you can also use environment variables)
Dialpad.configure do |config|
  config.base_url = ENV['DIALPAD_API_BASE_URL'] || 'https://api.dialpad.com'
  config.token = ENV['DIALPAD_API_TOKEN'] || 'your_token_here'
end

puts 'Dialpad Ruby Gem - Basic Usage Example'
puts '======================================'

begin
  # Example: List webhooks (using class methods)
  puts "\n1. Listing webhooks using class methods..."
  webhooks = Dialpad::Webhook.list
  puts "Found #{webhooks.length} webhooks"

  # Example: Create a webhook (using class methods)
  puts "\n2. Creating a webhook using class methods..."
  new_webhook = Dialpad::Webhook.create({
                                          url: 'https://example.com/webhook',
                                          events: ['call.completed', 'call.started']
                                        })
  puts "Created webhook with ID: #{new_webhook.id}"

  # Example: Retrieve the webhook (using class methods)
  puts "\n3. Retrieving webhook using class methods..."
  webhook = Dialpad::Webhook.retrieve(new_webhook.id)
  puts "Webhook URL: #{webhook.url}"

  # Example: Update the webhook (using class methods)
  puts "\n4. Updating webhook using class methods..."
  updated_webhook = Dialpad::Webhook.update(new_webhook.id,
                                            {
                                              url: 'https://example.com/updated-webhook'
                                            })
  puts "Updated webhook URL: #{updated_webhook.url}"

  # Example: List contacts (using class methods)
  puts "\n5. Listing contacts using class methods..."
  contacts = Dialpad::Contact.list
  puts "Found #{contacts.length} contacts"

  # Example: List calls (using class methods)
  puts "\n6. Listing calls using class methods..."
  calls = Dialpad::Call.list
  puts "Found #{calls.length} calls"

  # Example: List subscriptions (using class methods)
  puts "\n7. Listing subscriptions using class methods..."
  subscriptions = Dialpad::Subscription.list
  puts "Found #{subscriptions.length} subscriptions"

  # Example: Clean up - delete the webhook (using class methods)
  puts "\n8. Cleaning up using class methods..."
  Dialpad::Webhook.destroy(new_webhook.id)
  puts "Deleted webhook with ID: #{new_webhook.id}"

  # Example: Alternative usage with instance methods (still supported)
  puts "\n9. Alternative usage with instance methods..."
  webhook_instance = Dialpad.webhooks
  webhooks_alt = webhook_instance.list
  puts "Found #{webhooks_alt.length} webhooks using instance methods"
rescue Dialpad::ConfigurationError => e
  puts "Configuration Error: #{e.message}"
  puts 'Please set DIALPAD_API_BASE_URL and DIALPAD_API_TOKEN environment variables'
rescue Dialpad::APIError => e
  puts "API Error: #{e.message}"
rescue StandardError => e
  puts "Unexpected Error: #{e.message}"
end

puts "\nExample completed!"
