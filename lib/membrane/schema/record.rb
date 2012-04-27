require "set"

require "membrane/schema/base"

module Membrane
  module Schema
  end
end

class Membrane::Schema::Record < Membrane::Schema::Base
  attr_reader :schemas
  attr_reader :optional_keys

  def initialize(schemas, optional_keys = [])
    @optional_keys = Set.new(optional_keys)
    @schemas = schemas
  end

  def validate(object)
    unless object.kind_of?(Hash)
      return "Expected instance of Hash, given instance of #{object.class}"
    end

    key_errors = {}

    @schemas.each do |k, schema|
      errors = nil

      if object.has_key?(k)
        errors = schema.validate(object[k])
      elsif !@optional_keys.include?(k)
        errors = "Missing key"
      end

      key_errors[k] = errors if errors
    end

    if key_errors.empty?
      nil
    else
      "{ " + key_errors.map { |k, e| "#{k} => #{e}" }.join(", ") + " }"
    end
  end
end
