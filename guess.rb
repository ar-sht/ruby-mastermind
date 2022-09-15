# frozen_string_literal: true

require './feedback'

class Guess
  attr_accessor :guess, :candidates, :feedback_creator

  def initialize
    @guess = [1, 1, 2, 2]
    @candidates = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a.map { |x| x.join.to_i } - [@guess.join]
    @feedback_creator = Feedback.new
  end

  def make_guess(feedback_hash, guess)
    return guess unless feedback_hash

    eliminate(feedback_hash, guess)
  end

  private

  def eliminate(feedback_hash, guess)
    candidates.select! do |value|
      feedback_creator.feedback(guess, value, true, true) == feedback_hash
    end
  end
end
