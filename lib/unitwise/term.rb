require 'signed_multiset'
module Unitwise
  class Term < Liner.new(:compound, :factor, :exponent, :annotation)

    include Unitwise::Composable

    def compound=(value)
      value.is_a?(Compound) ? super(value) : super(Compound.find(value.to_s))
    end

    def special?
      compound.special?
    end

    def depth
      compound ? compound.depth + 1 : 0
    end

    def terminal?
      depth <= 4
    end

    def atom
      compound ? compound.atom : nil
    end

    def prefix
      compound ? compound.prefix : nil
    end

    def factor
      @factor ||= 1
    end

    def exponent
      @exponent ||= 1
    end

    def scalar
      (factor * (compound ? compound.scalar : 1)) ** exponent
    end

    def functional(x=scalar, forward=true)
      (factor * (compound ? compound.functional(x, forward) : 1)) ** exponent
    end

    def root_terms
      if terminal?
        [self]
      else
        compound.scale.root_terms.map do |t|
          self.class.new(compound: t.compound, exponent: t.exponent * exponent)
        end
      end
    end

    def *(other)
      if other.respond_to?(:terms)
        Unit.new(other.terms << self)
      elsif other.respond_to?(:compound)
        Unit.new([self, other])
      elsif other.is_a?(Numeric)
        self.class.new(to_hash.merge(factor: factor * other))
      end
    end

    def /(other)
      if other.respond_to?(:terms)
        Unit.new(other.terms.map{|t| t ** -1} << self)
      elsif other.respond_to?(:compound)
        Unit.new([self, other ** -1])
      elsif other.is_a?(Numeric)
        self.class.new(to_hash.merge(factor: factor / other))
      end
    end

    def **(integer)
      self.class.new(to_hash.merge(exponent: exponent * integer))
    end

    def to_s
      [(factor if factor != 1), compound, (exponent if exponent != 1)].compact.join('')
    end

  end
end