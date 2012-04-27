require "membrane/schema/base"

module Membrane
  module Schema
  end
end

class Membrane::Schema::List < Membrane::Schema::Base
  attr_reader :elem_schema

  def initialize(elem_schema)
    @elem_schema = elem_schema
  end

  def validate(object)
    unless object.kind_of?(Array)
      return "Expected instance of Array, given instance of #{object.class}"
    end

    errors = {}

    object.each_with_index do |elem, ii|
      if err = @elem_schema.validate(elem)
        errors[ii] = err
      end
    end

    if errors.empty?
      nil
    else
      errors.map { |ii, e| "At index #{ii}: #{e}" }.join(", ")
    end
  end
end
