# frozen_string_literal: true

class Sequence
  attr_reader :key

  # @param [Array] key - 4 numbers 0 to 5
  # @return [Nil] just sets @key to param
  def initialize(key = (1..4).reduce([]) { |arr, _| arr << Random.rand(1..6) })
    @key = key
  end
end
