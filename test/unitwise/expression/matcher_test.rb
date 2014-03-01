require 'test_helper'

describe Unitwise::Expression::Matcher do
  describe "::compound(:primary_code)" do
    subject { Unitwise::Expression::Matcher.compound(:primary_code) }
    it "must be an Alternative list" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse prefixed metrics" do
      subject.parse("km").must_equal("km")
    end
    it "must parse non-prefixed non-metrics" do
      subject.parse("[in_i]").must_equal("[in_i]")
    end
  end
  describe "::compound(:names)" do
    subject { Unitwise::Expression::Matcher.compound(:names)}
    it "must be an Alternative list of names" do
      subject.must_be_instance_of Parslet::Atoms::Alternative
    end
    it "must parse prefixed metric names" do
      subject.parse('kiloJoule').must_equal('kiloJoule')
    end
    it "must parse non-prefixed non-metric names" do
      subject.parse('inch').must_equal('inch')
    end
  end
end