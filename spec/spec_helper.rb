require 'simplecov'
SimpleCov.start 'test_frameworks' do
  add_filter '/formatter/'
end

require_relative '../winnie'

RSpec.configure do |config|
  config.order = "random"
  config.tty = true
  config.color = true
end
