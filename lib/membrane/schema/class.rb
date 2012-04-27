require "membrane/schema/base"

module Membrane
  module Schema
  end
end

class Membrane::Schema::Class < Membrane::Schema::Base
  attr_reader :klass

  def initialize(klass)
    @klass = klass
  end

  # Validates whether or not the supplied object is derived from klass
  #
  # @return [String, nil]
  def validate(object)
    if object.kind_of?(@klass)
      nil
    else
      "Expected instance of #{@klass}, given an instance of #{object.class}"
    end
  end
end
