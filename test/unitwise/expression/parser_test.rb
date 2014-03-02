require 'test_helper'

describe Unitwise::Expression::Parser do
  subject { Unitwise::Expression::Parser.new }
  describe '#compound' do
    it "must match non-prefixed metrics" do
      subject.compound.parse('N')[:compound].must_equal('N')
    end
    it "must match non-prefixed non-metrics" do
      subject.compound.parse('[in_i]')[:compound].must_equal('[in_i]')
    end
    it "must match prefixed metrics" do
      subject.compound.parse('kW')[:compound].must_equal('kW')
    end
  end


  describe '#annotation' do
    it "must match '{foobar}'" do
      subject.annotation.parse('{foobar}')[:annotation].must_equal('foobar')
    end
  end

  describe "#factor" do
    it "must match positives and fixnums" do
      subject.factor.parse('3.2')[:factor].must_equal(fixnum: '3.2')
    end
    it "must match negatives and integers" do
      subject.factor.parse('-5')[:factor].must_equal(integer: '-5')
    end
  end

  describe "#exponent" do
    it "must match positives integers" do
      subject.exponent.parse('4')[:exponent].must_equal(integer: '4')
    end
    it "must match negative integers" do
      subject.exponent.parse('-5')[:exponent].must_equal(integer: '-5')
    end
  end

  describe "term" do
    it "must match basic atoms" do
      subject.term.parse('[in_i]')[:term][:compound].must_equal('[in_i]')
    end
    it "must match prefixed atoms" do
      match = subject.term.parse('ks')[:term]
      match[:compound].must_equal('ks')
    end
    it "must match exponential atoms" do
      match = subject.term.parse('cm3')[:term]
      match[:compound].must_equal 'cm'
      match[:exponent][:integer].must_equal '3'
    end
    it "must match factors" do
      subject.term.parse('3.2')[:term][:factor][:fixnum].must_equal '3.2'
    end
    it "must match annotations" do
      match = subject.term.parse('N{Normal}')[:term]
      match[:compound].must_equal 'N'
      match[:annotation].must_equal 'Normal'
    end
  end

  describe '#group' do
    it "must match parentheses with a term" do
      match = subject.group.parse('(s2)')[:group][:nested][:left][:term]
      match[:compound].must_equal 's'
      match[:exponent][:integer].must_equal '2'
    end
    it "must match nested groups" do
      match = subject.group.parse('((kg))')[:group][:nested][:left][:group][:nested][:left][:term]
      match[:compound].must_equal 'kg'
    end
    it "must pass exponents down" do
      match = subject.group.parse('([in_i])3')[:group]
      match[:exponent][:integer].must_equal '3'
      match[:nested][:left][:term][:compound].must_equal '[in_i]'
    end
  end

  describe "#expression" do
    it "must match left only" do
      match = subject.expression.parse('m')
      match[:left][:term][:compound].must_equal("m")
    end
    it "must match left + right + operator" do
      match = subject.expression.parse('m.s')
      match[:left][:term][:compound].must_equal("m")
      match[:operator].must_equal('.')
      match[:right][:left][:term][:compound].must_equal('s')
    end
    it "must match operator + right" do
      match = subject.expression.parse("/s")
      match[:operator].must_equal('/')
      match[:right][:left][:term][:compound].must_equal('s')
    end
  end


end