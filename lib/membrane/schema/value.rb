require "membrane/schema/base"

module Membrane
  module Schema
  end
end

class Membrane::Schema::Value < Membrane::Schema::Base
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def validate(object)
    if object == @value
      nil
    else
      "Expected #{@value}, given #{object}"
    end
  end
end
