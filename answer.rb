# frozen_string_literal: true

require './sequence'
require 'pry-byebug'

class Answer < Sequence
  attr_reader :key
  # @param [Sequence] guess
  # @return [Array] matching output like in Mastermind, 0 = white peg, 1 = black peg, -1 = nothing
  def match(guess)
    local_key = @key.map { |x| x }
    guess.key.reduce([]) do |arr, val|
      if local_key.include?(val)
        local_key.delete_at(local_key.find_index(val))
        if @key[guess.key.find_index(val)] == val
          arr << 1
        else
          arr << 0
        end
      else
        arr << -1
      end
    end
  end
end
