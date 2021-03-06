require 'yaml'
module Unitwise
  # The base class that Atom and Prefix are extended from. This class provides
  # shared functionality for said classes.
  class Base
    liner :names, :primary_code, :secondary_code, :symbol, :scale

    # The list of tracked items.
    # @return [Array] An array of memoized instances.
    # @api public
    def self.all
      @all ||= data.map { |d| new d }
    end

    # Find a matching instance by a specified attribute.
    # @param string [String] The search term
    # @param method [Symbol] The attribute to search by
    # @return The first matching instance
    # @example
    #   Unitwise::Atom.find('m')
    # @api public
    def self.find(string, method = :primary_code)
      all.find do |i|
        key = i.send(method)
        if key.respond_to?(:each)
          key.include?(string)
        else
          key == string
        end
      end
    end

    # Setup a new instance. Takes a hash of attributes, or an array of
    # attribute values.
    # @api public
    def initialize(*args)
      super(*args)
      freeze
    end

    # Setter for the names attribute. Will always set as an array.
    # @api semipublic
    def names=(names)
      @names = Array(names)
    end

    # A set of method friendly names.
    # @return [Array] An array of strings
    # @api semipublic
    def slugs
      names.map do |n|
        n.downcase.strip.gsub(/\s/, '_').gsub(/\W/, '')
      end
    end

    # String representation for the instance.
    # @return [String]
    # @api public
    def to_s
      primary_code
    end
  end
end
