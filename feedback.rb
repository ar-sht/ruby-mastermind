# frozen_string_literal: true

require './guess'
require 'pry-byebug'
class Feedback
  attr_accessor :answer, :guess, :feedback_arr

  def feedback(answer, guess, computer)
    @answer = answer.map { |val| val }
    @guess = guess.map { |val| val }
    @feedback_arr = []
    # binding.pry
    populate_arr
    if computer
      num_matches = feedback_arr.count { |value| value == 1 }
      num_partials = feedback_arr.count(&:zero?)
      [num_matches, num_partials]
    else
      feedback_arr
    end
  end

  def populate_arr
    matches
    partials
  end

  def matches
    4.times do |i|
      # binding.pry
      if answer[i] == guess[i]
        feedback_arr.push(1)
        answer[i] = 7
        guess[i] = 8
      else
        feedback_arr[i] = -1
      end
    end
  end

  def partials
    4.times do |i|
      next unless answer.include?(guess[i])

      feedback_arr[i] = 0
      answer[answer.find_index(guess[i])] = 7
      guess[i] = 8
    end
  end
end
