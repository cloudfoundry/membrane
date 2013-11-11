require "spec_helper"

describe Membrane::Schemas::Record do
  describe "#validate" do
    it "should return an error if the validated object isn't a hash" do
      schema = Membrane::Schemas::Record.new(nil)

      expect_validation_failure(schema, "test", /instance of Hash/)
    end

    it "should return an error for missing keys" do
      key_schemas = { "foo" => Membrane::Schemas::Any.new }
      rec_schema = Membrane::Schemas::Record.new(key_schemas)

      expect_validation_failure(rec_schema, {}, /foo => Missing/)
    end

    it "should validate the value for each key" do
      data = {
        "foo" => 1,
        "bar" => 2,
      }

      key_schemas = {
        "foo" => mock("foo"),
        "bar" => mock("bar"),
      }

      key_schemas.each { |k, m| m.should_receive(:validate).with(data[k]) }

      rec_schema = Membrane::Schemas::Record.new(key_schemas)

      rec_schema.validate(data)
    end

    it "should return all errors for keys or values that didn't validate" do
      key_schemas = {
        "foo" => Membrane::Schemas::Any.new,
        "bar" => Membrane::Schemas::Class.new(String),
      }

      rec_schema = Membrane::Schemas::Record.new(key_schemas)

      errors = nil

      begin
        rec_schema.validate({ "bar" => 2 })
      rescue Membrane::SchemaValidationError => e
        errors = e.to_s
      end

      errors.should match(/foo => Missing key/)
      errors.should match(/bar/)
    end

    it "raises an error if there are extra keys that are not matched in the schema" do
      data = {
        "key" => "value",
        "other_key" => 2,
      }

      rec_schema = Membrane::Schemas::Record.new({
        "key" => Membrane::Schemas::Class.new(String)
      })

      expect {
        rec_schema.validate(data)
      }.to raise_error(/other_key .* was not specified/)
    end
  end

  end
end
