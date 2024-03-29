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
