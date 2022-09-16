class Guess
  attr_accessor :sequence

  def initialize(sequence)
    @sequence = sequence.split(//).map(&:to_i)
  end

  def valid?
    # length must be 4, all numbers must be 1-6
    sequence.length == 4 && sequence.select { |num| num.positive? && num <= 6 } == sequence
  end
end
