# frozen_string_literal: true
require './player'

class HumanPlayer < Player
  attr_accessor :name

  def make_code
    create_code
  end

  def make_guess
    create_guess
  end

  private

  def create_code
    puts "Ok then, #{name}. Please enter the code you'd like the computer to guess:"
    code = gets.chomp.split(//).map(&:to_i)
    until valid_code?(code)
      puts 'Invalid Input. Please try again:'
      code = gets.chomp.split(//).map(&:to_i)
    end
    code
  end

  def create_guess
    puts 'Please enter your guess:'
    puts "#{'=' * 80}"
    code = gets.chomp.split(//).map(&:to_i)
    until valid_code?(code)
      puts 'Invalid Input. Please try again:'
      puts "#{'=' * 80}\n"
      code = gets.chomp.split(//).map(&:to_i)
    end
    code
  end

  def valid_code?(code)
    code.join =~ /^[1-6]{4}$/
  end
end
