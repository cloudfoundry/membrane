require "membrane/errors"
require "membrane/schemas/base"

module Membrane
  module Schema
  end
end

class Membrane::Schemas::Regexp < Membrane::Schemas::Base
  attr_reader :regexp

  def initialize(regexp)
    @regexp = regexp
  end

  def validate(object)
    if !object.kind_of?(String)
      emsg = "Expected instance of String, given instance of #{object.class}"
      raise Membrane::SchemaValidationError.new(emsg)
    end

    if !regexp.match(object)
      emsg = "Value #{object} doesn't match regexp #{@regexp}"
      raise Membrane::SchemaValidationError.new(emsg)
    end

    nil
  end
end
