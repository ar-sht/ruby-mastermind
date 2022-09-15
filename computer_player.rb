require './player'
require './guess'

class ComputerPlayer < Player
  attr_accessor :guess, :current_guess

  def initialize
    super('Computer')
  end

  def make_code
    [rand(1..6), rand(1..6), rand(1..6), rand(1..6)]
  end

  def make_guess(feedback)
    init_guess if feedback.nil?
    self.current_guess = guess.make_guess(feedback, current_guess)
    current_guess
  end

  private

  def init_guess
    @guess = Guess.new
  end
end
