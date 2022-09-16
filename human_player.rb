# frozen_string_literal: true
require './player'
require './guess'
class HumanPlayer < Player
  attr_accessor :name, :code, :guess, :score

  def initialize(name)
    @score = 0
    super(name)
  end
  def make_guess
    puts 'Please enter your guess:'
    guess = Guess.new(gets.chomp)
    until guess.valid?
      puts 'Invalid Input. Please re-enter your guess:'
      guess = Guess.new(gets.chomp)
    end
    guess.sequence
  end

  def make_code
    puts 'Please enter your code:'
    code = Guess.new(gets.chomp)
    until code.valid?
      puts 'Invalid Input. Please re-enter your code:'
      code = Guess.new(gets.chomp)
    end
    code.sequence
  end
end
