require "set"

require "membrane/errors"
require "membrane/schemas/base"

class Membrane::Schemas::Bool < Membrane::Schemas::Base
  TRUTH_VALUES = Set.new([true, false])

  def validate(object)
    if !TRUTH_VALUES.include?(object)
      emsg = "Expected instance of true or false, given #{object}"
      raise Membrane::SchemaValidationError.new(emsg)
    end
  end
end
