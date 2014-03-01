require 'liner'

require "unitwise/version"
require 'unitwise/base'
require 'unitwise/expression'
require 'unitwise/composable'
require 'unitwise/scale'
require 'unitwise/functional'
require 'unitwise/measurement'
require 'unitwise/atom'
require 'unitwise/prefix'
require 'unitwise/compound'
require 'unitwise/term'
require 'unitwise/unit'
require 'unitwise/errors'

# Unitwise is a library for performing mathematical operations and conversions 
# on all units defined by the [Unified Code for Units of Measure(UCUM).
module Unitwise
  # The system path for the installed gem
  # @api private
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  # A helper to get the location of a yaml data file
  # @api private
  def self.data_file(key)
    File.join path, "data", "#{key}.yaml"
  end
end

# Measurement initializer shorthand. Use this to instantiate new measurements.
# @param first [Numeric, String] Either a numeric value or a unit expression
# @param last [String, Nil] Either a unit expression, or nil
# @return [Unitwise::Measurement]
# @example
#   Unitwise(20, 'mile') # => #<Unitwise::Measurement 20 mile>
#   Unitwise('km') # => #<Unitwise::Measurement 1 km>
# @api public
def Unitwise(first, last=nil)
  if last
    Unitwise::Measurement.new(first, last)
  else
    Unitwise::Measurement.new(1, first)
  end
end

