# frozen_string_literal: true
require './player'
require './guess'
require 'pry-byebug'

class ComputerPlayer < Player
  attr_accessor :name, :code, :guess, :viable_codes, :feedbacker, :score, :all_possible_codes

  def initialize(name = 'Computer')
    @all_possible_codes = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    @viable_codes = all_possible_codes.map { |x| x }
    @guess = [0] * 4
    @feedbacker = Feedback.new
    @score = 0
    super(name)
  end

  def make_code
    ([0] * 4).map { |_| rand(1..6) }
  end

  def make_guess(last_guess, feedback)
    prune_guesses(last_guess, feedback)
    @guess = find_best_guess
  end

  def prune_guesses(last_guess, feedback)
    viable_codes.select! { |code| feedback == feedbacker.feedback(code, last_guess, true) }
    viable_codes.delete(last_guess)
  end

  def find_best_guess
    return [1, 1, 2, 2] if @guess == [0, 0, 0, 0]

    scores = {}
    guess_codes = []
    viable_codes.each do |g|
      code = g.join.to_i
      score_holder = {}
      viable_codes.each do |c|
        score = feedbacker.feedback(c, g, true)
        score_holder[score] = score_holder[score].nil? ? 1 : score_holder[score] + 1
      end
      maximum = score_holder.values.max
      scores[code] = maximum
    end
    minimum = scores.values.min
    # binding.pry
    viable_codes.each { |code| guess_codes.push(code) if scores[code.join.to_i] == minimum }
    good_ones = viable_codes.select { |sequence| guess_codes.include?(sequence) }
    good_ones[0]
  end
end
