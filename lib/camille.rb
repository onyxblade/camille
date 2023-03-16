# frozen_string_literal: true

require "active_support"

require_relative "camille/version"
require_relative "camille/basic_type"
require_relative "camille/types"
require_relative "camille/types/number"
require_relative "camille/types/string"
require_relative "camille/types/boolean"
require_relative "camille/types/array"
require_relative "camille/types/object"
require_relative "camille/types/null"
require_relative "camille/types/undefined"
require_relative "camille/types/union"
require_relative "camille/types/tuple"
require_relative "camille/types/any"
require_relative "camille/type"
require_relative "camille/type_error"
require_relative "camille/type_error_printer"
require_relative "camille/syntax"
require_relative "camille/endpoint"
require_relative "camille/schema"
require_relative "camille/schemas"
require_relative "camille/line"
require_relative "camille/railtie"
require_relative "camille/controller_extension"
require_relative "camille/loader"
require_relative "camille/configuration"
require_relative "camille/code_generator"
require_relative "camille/main_controller"

require "rails/generators"
require_relative "camille/generators/install_generator"
require_relative "camille/generators/type_generator"
require_relative "camille/generators/schema_generator"

module Camille
  class Error < StandardError; end

  def self.configure &block
    Camille::Configuration.instance_eval &block
  end

  def self.generate_ts
    Camille::CodeGenerator.generate_ts
  end
end
