require "membrane/errors"
require "membrane/schemas/base"

class Membrane::Schemas::Class < Membrane::Schemas::Base
  attr_reader :klass

  def initialize(klass)
    @klass = klass
  end

  # Validates whether or not the supplied object is derived from klass
  def validate(object)
    if !object.kind_of?(@klass)
      emsg = "Expected instance of #{@klass}," \
             + " given an instance of #{object.class}"
      raise Membrane::SchemaValidationError.new(emsg)
    end
  end
end
