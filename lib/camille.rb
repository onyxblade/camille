# frozen_string_literal: true

require_relative "camille/version"
require_relative "camille/type"
require_relative "camille/types/number"
require_relative "camille/types/string"
require_relative "camille/types/boolean"
require_relative "camille/types/array"
require_relative "camille/types/object"
require_relative "camille/types/null"
require_relative "camille/types/undefined"
require_relative "camille/types/union"
require_relative "camille/type_store"
require_relative "camille/type_resolver"

module Camille
  class Error < StandardError; end
  # Your code goes here...
end
