require "membrane/schema/base"

module Membrane
  module Schema
  end
end

class Membrane::Schema::Enum < Membrane::Schema::Base
  attr_reader :elem_schemas

  def initialize(*elem_schemas)
    @elem_schemas = elem_schemas
    @elem_schema_str = elem_schemas.map { |s| s.to_s }.join(", ")
  end

  def validate(object)
    @elem_schemas.each { |schema| return nil if schema.validate(object).nil? }

    "Object #{object} doesn't validate against any of #{@elem_schema_str}"
  end
end
