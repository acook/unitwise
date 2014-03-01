module Unitwise
  module Expression
    class Matcher
      class << self
        def compound(method)
          new(Compound.all, method).alternative
        end
      end

      attr_reader :collection, :method

      def initialize(collection, method=:primary_code)
        @collection = collection
        @method = method
      end

      def strings
        @stings ||= collection.map(&method).flatten.compact.sort do |x,y|
          y.length <=> x.length
        end
      end

      def matchers
        @matchers ||= strings.map {|s| Parslet::Atoms::Str.new(s) }
      end

      def alternative
        @alternative ||= Parslet::Atoms::Alternative.new(*matchers)
      end

    end
  end
end