module Unitwise
  class Atom < Base
    attr_accessor :classification, :property, :metric, :special
    attr_accessor :arbitrary, :function, :dim

    class << self
      def data
        @data ||= data_files.reduce([]){|m,f| m += YAML::load File.open(f)}
      end

      def data_files
        %w(base_unit derived_unit).map{|type| Unitwise.data_file type}
      end
    end

    def base?
      scale.nil? && dim
    end

    def derived?
      !base?
    end

    def metric?
      base? ? true : !!metric
    end

    def special?
      !!special
    end

    def arbitrary?
      !!arbitrary
    end

    def dimless?
      classification == 'dimless'
    end

    def root?
      base? || dimless?
    end

    def scale=(attributes)
      if attributes
        @scale = Scale.new.tap do |s|
          attributes.each do |k,v|
            s.send :"#{k}=", v
          end
        end
      end
    end

    def root_terms
      scale.root_terms unless root?
    end

  end
end