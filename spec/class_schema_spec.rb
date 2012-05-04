require "spec_helper"


describe Membrane::Schema::Class do
  describe "#validate" do
    let(:schema) { Membrane::Schema::Class.new(String) }

    it "should return nil for instances of the supplied class" do
      schema.validate("test").should be_nil
    end

    it "should return nil for subclasses of the supplied class" do
      class StrTest < String; end

      schema.validate(StrTest.new("hi")).should be_nil
    end

    it "should return an error for non class instances" do
      expect_validation_failure(schema, 10, /instance of String/)
    end
  end

  describe "#to_s" do
    it "should call 'name' on the underlying class" do
      klass = mock("klass")
      klass.should_receive(:name)

      Membrane::Schema::Class.new(klass).to_s
    end
  end
end
