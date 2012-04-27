require "membrane/schema"

module Membrane
end

class Membrane::SchemaParser
  class Dsl
    OptionalKeyMarker = Struct.new(:key)
    DictionaryMarker = Struct.new(:key_schema, :value_schema)
    EnumMarker = Struct.new(:elem_schemas)

    def any
      Membrane::Schema::Any.new
    end

    def bool
      Membrane::Schema::Bool.new
    end

    def enum(*elem_schemas)
      EnumMarker.new(elem_schemas)
    end

    def dict(key_schema, value_schema)
      DictionaryMarker.new(key_schema, value_schema)
    end

    def optional(key)
      Dsl::OptionalKeyMarker.new(key)
    end
  end

  def self.parse(&blk)
    new.parse(&blk)
  end

  def parse(&blk)
    intermediate_schema = Dsl.new.instance_eval(&blk)

    do_parse(intermediate_schema)
  end

  private

  def do_parse(object)
    case object
    when Hash
      parse_record(object)
    when Array
      parse_list(object)
    when Class
      Membrane::Schema::Class.new(object)
    when Dsl::DictionaryMarker
      Membrane::Schema::Dictionary.new(do_parse(object.key_schema),
                                       do_parse(object.value_schema))
    when Dsl::EnumMarker
      elem_schemas = object.elem_schemas.map { |s| do_parse(s) }
      Membrane::Schema::Enum.new(*elem_schemas)

    when Membrane::Schema::Base
      object
    else
      Membrane::Schema::Value.new(object)
    end
  end

  def parse_list(schema)
    if schema.empty?
      raise ArgumentError.new("You must supply a schema for elements.")
    elsif schema.length > 1
      raise ArgumentError.new("Lists can only match a single schema.")
    end

    Membrane::Schema::List.new(do_parse(schema[0]))
  end

  def parse_record(schema)
    if schema.empty?
      raise ArgumentError.new("You must supply at least one key-value pair.")
    end

    optional_keys = []

    parsed = {}

    schema.each do |key, value_schema|
      if key.kind_of?(Dsl::OptionalKeyMarker)
        key = key.key
        optional_keys << key
      end

      parsed[key] = do_parse(value_schema)
    end

    Membrane::Schema::Record.new(parsed, optional_keys)
  end
end
