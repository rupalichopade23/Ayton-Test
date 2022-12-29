# frozen_string_literal: true

require "active_support/concern"
require "halloumi"
require "halloumi/filters"

# Load all Ruby files in the `stacks/*_stacks/` directory
Dir.glob(
  File.expand_path("../", __FILE__) + "/stacks/*_stack/*.rb"
).each do |file|
  require file
end

# Load all Ruby files in the `shared_concerns` directory
Dir[
  File.expand_path("../shared_concerns/", __FILE__) + "/*.rb"
].each do |file|
  require file
end

# Load all Ruby files in the `stacks` directory
Dir.glob(
  File.expand_path("../", __FILE__) + "/stacks/*_stack.rb"
).each do |file|
  require file
end
