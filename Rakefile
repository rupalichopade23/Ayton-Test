require "rubygems"
require "bundler"
Bundler.setup

require "halloumi-tasks/tasks"
require "halloumi-tasks/tasks/lambda"

require "./lib/main"

task :pry do
  require "pry"
  require "awesome_print"
  require_relative "lib/halloumi"
  ARGV.clear
  Pry.start
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new

require "rubocop"
require "rubocop/rake_task"
require "rubocop/formatter/base_formatter"
require "rubocop/formatter/junit_formatter"
desc "Run RuboCop on the lib directory"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = true
  task.patterns = ["lib/**/*.rb"]
  task.options << "--format"
  task.options << "progress"
  task.options << "--format"
  task.options << "RuboCop::Formatter::JUnitFormatter"
  task.options << "--out"
  task.options << "test-reports/rubocop.xml"
end

require "yard"
YARD::Rake::YardocTask.new

require "cloudformationcop/tasks"
CloudFormationCop::Tasks.install_tasks
desc "Run CloudFormationCop on the template"
task :cloudformationcop do
  Rake::Task["cfcop"].invoke("build/#{ENV["STACK_NAME"]}.json")
end

task run: ["cloudformation:compile", :cloudformationcop]
task test: %i(rubocop spec yard)
task default: %i(test run)
