require 'rubygems'
require 'spork'
require 'rspec'

Spork.prefork do
  RSpec.configure do |config|
    config.mock_with :rspec
    config.color_enabled = true
  end
end
