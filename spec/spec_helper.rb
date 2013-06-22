require 'rspec'
require 'yaml'

require_relative '../lib/school_holidays'
require_relative '../lib/school_holidays/school_holiday'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end