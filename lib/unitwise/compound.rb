module Unitwise
  class Compound < Liner.new(:atom, :prefix)
    def self.all
      @all ||= build
    end

    def self.build
      compounds = Atom.all.map { |a| new(a) }
      Atom.all.select(&:metric?).each do |a|
        Prefix.all.each do |p|
          compounds << new(a, p)
        end
      end
      compounds
    end

    def self.find(term)
      all.find { |i| i.search_strings.any? { |string| string == term } }
    end

    def self.find_by(method, string)
      self.all.find do |i|
        key = i.send(method)
        if key.respond_to?(:each)
          key.include?(string)
        else
          key == string
        end
      end
    end

    
    [:primary_code, :secondary_code, :symbol].each do |meth|
      define_method meth do
        prefix ? "#{prefix.send meth}#{atom.send meth}" : atom.send(meth)
      end
    end

    [:names, :slugs].each do |meth|
      define_method meth do
        prefix ? prefix.send(meth).zip(atom.send(meth)).map{ |set| set.join('') } : atom.send(meth)
      end
    end

    def atom=(value)
      value.is_a?(Atom) ? super(value) : super(Atom.find value)
    end
    
    def prefix=(value)
      value.is_a?(Prefix) ? super(value) : super(Prefix.find value)
    end

    def scale
      atom.scale
    end

    def special?
      atom.special?
    end

    def functional(x=scalar, forward=true)
      f = atom.functional(x, forward)
      prefix ? f * prefix.scalar : f
    end

    def scalar
      prefix ? prefix.scalar * atom.scalar : atom.scalar
    end

    def depth
      atom.depth + 1
    end

    def search_strings
      [primary_code, secondary_code, names, slugs, symbol].flatten.compact
    end

    def to_s
      prefix.to_s + atom.to_s
    end

  end
end
