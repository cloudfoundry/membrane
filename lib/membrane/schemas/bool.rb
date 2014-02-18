require "set"

require "membrane/errors"
require "membrane/schemas/base"

class Membrane::Schemas::Bool < Membrane::Schemas::Base
  def validate(object)
    BoolValidator.new(object).validate
  end

  class BoolValidator
    TRUTH_VALUES = Set.new([true, false])

    def initialize(object)
      @object = object
    end

    def validate
      if !TRUTH_VALUES.include?(@object)
        fail!
      end
    end

    private

    def fail!
      emsg = "Expected instance of true or false, given #{@object}"
      raise Membrane::SchemaValidationError.new(emsg)
    end
  end
end
