require "membrane/schema/base"

module Membrane
  module Schema
  end
end

class Membrane::Schema::Dictionary
  attr_reader :key_schema
  attr_reader :value_schema

  def initialize(key_schema, value_schema)
    @key_schema = key_schema
    @value_schema = value_schema
  end

  def validate(object)
    unless object.kind_of?(Hash)
      return "Expected instance of Hash, given instance of #{object.class}."
    end

    errors = {}

    object.each do |k, v|
      err = @key_schema.validate(k) || @value_schema.validate(v)
      errors[k] = err unless err.nil?
    end

    if errors.empty?
      nil
    else
      "{ " + errors.map { |k, e| "#{k} => #{e}" }.join(", ") + " }"
    end
  end
end
