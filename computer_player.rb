require './player'
require './guess'
require 'pry-byebug'

class ComputerPlayer < Player
  attr_accessor :name, :code, :guess, :all_guesses, :feedbacker, :score

  def initialize(name = 'Computer')
    @all_guesses = [[1, 1, 2, 2]] + [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    @guess = []
    @feedbacker = Feedback.new
    @score = 0
    super(name)
  end

  def make_code
    ([0] * 4).map { |_| rand(1..6) }
  end

  def make_guess(answer)
    all_guesses.select! do |combo|
      feedbacker.feedback(answer, guess, true) == feedbacker.feedback(combo, guess, true)
    end
    # binding.pry
    @guess = all_guesses[0]
  end
end
