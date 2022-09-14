# frozen_string_literal: true

require './answer'
class Guesser
  attr_reader :name, :guess

  def initialize(name = 'Computer')
    @name = name
    @guess = Sequence.new([0] * 4)
  end

  def make_guess
    @guess = Sequence.new(gets
                            .chomp
                            .split
                            .map(&:to_i))
  end

  def computer_guess(arr)
    @guess = Sequence.new(arr)
  end
end
