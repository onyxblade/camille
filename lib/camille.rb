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
require_relative "camille/type"
require_relative "camille/type_error"
require_relative "camille/type_error_printer"
require_relative "camille/core_ext"
require_relative "camille/endpoint"
require_relative "camille/schema"
require_relative "camille/schemas"

module Camille
  class Error < StandardError; end
  # Your code goes here...
end
