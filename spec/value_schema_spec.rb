require "spec_helper"


describe Membrane::Schema::Value do
  describe "#validate" do
    let(:schema) { Membrane::Schema::Value.new("test") }

    it "should return nil for values that are equal" do
      schema.validate("test").should be_nil
    end

    it "should return an error for values that are not equal" do
      expect_validation_failure(schema, "tast", /Expected test/)
    end
  end

  describe "#to_s" do
    it "should proxy to the value in the schema" do
      val = mock("value")
      val.should_receive(:to_s)

      schema = Membrane::Schema::Value.new(val)

      schema.to_s
    end
  end
end
