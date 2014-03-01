module Unitwise
  # A Unitwise::Unit is essentially a collection of terms
  # This class should be considered privateish.
  class Unit
    liner :expression, :terms

    include Unitwise::Composable

    # Create a new Unit
    # @param input [Array, String]
    # @api public
    def initialize(input)
      if input.respond_to?(:expression)
        @expression = input.expression
        @terms = input.terms
      elsif input.respond_to?(:each)
        @terms = input
      else
        @expression = input.to_s
      end
    end

    def expression
      @expression ||= (Expression.compose(@terms) if @terms)
    end

    def terms
      @terms ||= (Expression.decompose(@expression) if @expression)
    end

    def atoms
      terms.map(&:atom)
    end

    def special?
      terms.count >=1 && terms.all?(&:special?)
    end

    def functional(x=scalar, forward=true)
      terms.first.functional(x, forward)
    end

    def depth
      terms.map(&:depth).max + 1
    end

    def root_terms
      terms.flat_map(&:root_terms)
    end

    def scalar
      terms.map(&:scalar).inject(&:*)
    end

    def *(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms)
      elsif other.respond_to?(:atom)
        self.class.new(terms << other)
      elsif other.is_a?(Numeric)
        self.class.new(terms.map{ |t| t * other })
      else
        raise TypeError, "Can't multiply #{inspect} by #{other}."
      end
    end

    def /(other)
      if other.respond_to?(:terms)
        self.class.new(terms + other.terms.map{ |t| t ** -1})
      elsif other.respond_to?(:atom)
        self.class.new(terms << other ** -1)
      else
        raise TypeError, "Can't divide #{inspect} by #{other}."
      end
    end

    def **(number)
      self.class.new(terms.map{ |t| t ** number })
    end

    def to_s
      expression
    end
  end
end