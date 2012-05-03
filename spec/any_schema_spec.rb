require "spec_helper"

describe Membrane::Schema::Any do
  describe "#validate" do
    it "should always return nil" do
      schema = Membrane::Schema::Any.new
      # Smoke test more than anything. Cannot validate this with 100%
      # certainty.
      [1, "hi", :test, {}, []].each do |o|
        schema.validate(o).should be_nil
      end
    end
  end

  describe "#to_s" do
    it "should return 'any'" do
      schema = Membrane::Schema::Any.new

      schema.to_s.should == "any"
    end
  end
end
