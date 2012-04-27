require "spec_helper"

describe Membrane::Schema::Record do
  describe "#validate" do
    it "should return an error if the validated object isn't a hash" do
      schema = Membrane::Schema::Record.new(nil)

      schema.validate("test").should match(/instance of Hash/)
    end

    it "should return an error for missing keys" do
      key_schemas = { "foo" => Membrane::Schema::ANY }
      rec_schema = Membrane::Schema::Record.new(key_schemas)

      rec_schema.validate({}).should match(/foo/)
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

      rec_schema = Membrane::Schema::Record.new(key_schemas)

      rec_schema.validate(data)
    end

    it "should return all errors for keys or values that didn't validate" do
      key_schemas = {
        "foo" => Membrane::Schema::ANY,
        "bar" => Membrane::Schema::Class.new(String),
      }

      rec_schema = Membrane::Schema::Record.new(key_schemas)

      errors = rec_schema.validate({ "bar" => 2 })

      errors.should match(/foo => Missing key/)
      errors.should match(/bar/)
    end
  end
end
