require "spec_helper"


describe Membrane::Schema::Bool do
  describe "#validate" do
    let(:schema) { Membrane::Schema::Bool.new }

    it "should return nil for {true, false}" do
      [true, false].each { |v| schema.validate(v).should be_nil }
    end

    it "should return an error for values not in {true, false}" do
      ["a", 1].each do |v|
        expect_validation_failure(schema, v, /true or false/)
      end
    end
  end

  describe "#to_s" do
    it "should return 'bool'" do
      Membrane::Schema::Bool.new.to_s.should == "bool"
    end
  end
end
