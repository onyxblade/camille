# frozen_string_literal: true

require "camille"

require_relative "./../lib/camille/generators/templates/date_time"
require_relative "./../lib/camille/generators/templates/decimal"

require_relative "file_helpers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FileHelpers
end

RSpec::Matchers.define :be_checked do |expected|
  match do |actual|
    actual.instance_of? Camille::Checked
  end
end

RSpec::Matchers.define :have_checked_value do |expected|
  match do |actual|
    actual.instance_of?(Camille::Checked) && actual.value == expected
  end
end

RSpec::Matchers.define :be_type_error do |expected|
  match do |actual|
    actual.instance_of? Camille::TypeError
  end
end

RSpec::Matchers.define :be_basic_type_error do |expected|
  match do |actual|
    actual.instance_of?(Camille::TypeError) && actual.basic?
  end
end

RSpec::Matchers.define :be_composite_type_error do |expected|
  match do |actual|
    actual.instance_of?(Camille::TypeError) && !actual.basic?
  end
end