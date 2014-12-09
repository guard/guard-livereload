require "bundler/gem_tasks"

require "rspec/core/rake_task"

def ci?
  ENV["CI"] == "true"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = ci?
end

default_tasks = [:spec]

unless ci?
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop)
  default_tasks << :rubocop
end

task default: default_tasks
