module Unitwise
  module Expression
    class Transformer < Parslet::Transform

      rule(integer: simple(:i)) { i.to_i }
      rule(fixnum: simple(:f)) { f.to_f }

      rule(compound_code: simple(:c)) { |ctx| Compound.find_by(ctx[:key], ctx[:c]) }
      rule(term: subtree(:h))    { Term.new(h) }

      rule(operator: simple(:o), right: simple(:r)) do
        o == '/' ? r ** -1 : r
      end

      rule(left: simple(:l), operator: simple(:o), right: simple(:r)) do
        o == '/' ? l / r : l * r
      end

      rule(left: simple(:l)) { l }

      rule(group: { factor: simple(:f) , nested: simple(:n), exponent: simple(:e) }) do
        ( n ** e ) * f
      end
      rule(group: { nested: simple(:n) , exponent: simple(:e)}) { n ** e }

      rule(group: { nested: simple(:n) }) { n }
    end
  end
end