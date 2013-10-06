require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'guard/livereload'
ENV["GUARD_ENV"] = 'test'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
