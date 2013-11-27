require "membrane/errors"
require "membrane/schemas/base"

module Membrane
  module Schema
  end
end

class Membrane::Schemas::Dictionary < Membrane::Schemas::Base
  attr_reader :key_schema
  attr_reader :value_schema

  def initialize(key_schema, value_schema)
    @key_schema = key_schema
    @value_schema = value_schema
  end

  def validate(object)
    if !object.kind_of?(Hash)
      emsg = "Expected instance of Hash, given instance of #{object.class}."
      raise Membrane::SchemaValidationError.new(emsg)
    end

    errors = {}

    object.each do |k, v|
      begin
        @key_schema.validate(k)
        @value_schema.validate(v)
      rescue Membrane::SchemaValidationError => e
        errors[k] = e.to_s
      end
    end

    if errors.size > 0
      emsg = "{ " + errors.map { |k, e| "#{k} => #{e}" }.join(", ") + " }"
      raise Membrane::SchemaValidationError.new(emsg)
    end
  end
end
