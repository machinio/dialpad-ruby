require 'bundler/setup'
require 'dialpad'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # Reset configuration before each test
    Dialpad.base_url = nil
    Dialpad.token = nil
    Dialpad.instance_variable_set(:@client, nil)
  end
end
