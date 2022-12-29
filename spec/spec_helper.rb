require "dotenv"
Dotenv.overload File.expand_path("../.env", __FILE__)

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "json"
require "halloumi"
require "rspec"
require "rspec/its"

require "main"
require "support/shared_examples/a_security_group_rule"

RSpec.configure do |config|
  config.color = true
  config.formatter = "documentation"
  # config.raise_errors_for_deprecations!

  config.mock_with :rspec do |c|
    c.syntax = %i(should expect)
  end

  config.filter_run_excluding broken: true
  config.filter_run_excluding turn_off: true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]
end
