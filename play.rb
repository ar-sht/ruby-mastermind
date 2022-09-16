# frozen_string_literal: true
require './display'
require 'terminal-table'

class Play
  include Display
  attr_accessor :length, :role, :computer, :human, :name, :feedbacker

  def initialize
    @computer = ComputerPlayer.new
    @human = HumanPlayer.new('Placeholder')
    @feedbacker = Feedback.new
    puts 'WELCOME TO MASTERMIND'.colorize(:cyan)
  end

  def set_name
    puts 'Please enter your name:'.colorize(:green)
    human.name = gets.chomp.capitalize
  end

  def determine_length
    puts 'How many rounds would you like the game to last? Must be an even number less than 12:'.colorize(:green)
    @length = gets.chomp.to_i
    until @length <= 12 && @length.even? && @length.to_i == @length
      puts 'Invalid Input. Please try again:'.colorize(:green)
      @length = gets.chomp.to_i
    end
  end

  def determine_role
    puts "1. Code Maker
2. Code Breaker".colorize(:cyan)
    puts 'Which role would you like to play first?'.colorize(:green)
    @role = gets.chomp.to_i - 1
    until [0, 1].include?(@role)
      puts 'Invalid Input please try again:'.colorize(:green)
      @role = gets.chomp.to_i - 1
    end
  end

  def play_round
    puts "\u25AC" * TERM_WIDTH
    if role == 1
      puts 'You are the Code Breaker.'.colorize(:cyan)
      puts 'Would you like to play on hard mode? (y/n)'.colorize(:green)
      hard = gets.chomp.downcase[0] == 'y'
      print "\e[1J\e[H"
      puts 'Generating code....'.colorize(:cyan)
      answer = computer.make_code
      (1..4).each do |_num|
        print " \u2053 ".colorize(:green)
        sleep(0.150)
      end
      puts "\n#{"\u25AC" * TERM_WIDTH}"
      (1..12).each do |i|
        puts "Guess ##{i} of 12:".colorize(:green)
        guess = human.make_guess
        display_guess(guess)
        feedback = feedbacker.feedback(answer, guess, false)
        display_result(feedback, hard)
        puts "\u25AC" * TERM_WIDTH
        computer.score += 1
        next unless feedback == [1, 1, 1, 1]

        puts "Congratulations! You successfully guessed the code in just #{i.to_s.colorize(:magenta)} turns!".colorize(:cyan)
        break
      end
    else
      puts 'You are the Code Maker.'.colorize(:cyan)
      answer = human.make_code
      display_guess(answer)
      puts "\n#{"\u25AC" * TERM_WIDTH}"
      computer.guess = [0, 0, 0, 0]
      good_feedback = feedbacker.feedback(answer, computer.guess, true)
      (1..12).each do |i|
        puts "Guess ##{i} of 12:".colorize(:green)
        computer.make_guess(computer.guess, good_feedback)
        feedback_to_display = feedbacker.feedback(answer, computer.guess, false)
        good_feedback = feedbacker.feedback(answer, computer.guess, true)
        display_computer_guess(computer.guess)
        display_result(feedback_to_display, true)
        puts "\u25AC" * TERM_WIDTH
        human.score += 1
        sleep(0.750)
        next unless feedback_to_display == [1, 1, 1, 1]

        puts "Dang! The computer guessed your code in just #{i.to_s.colorize(:magenta)} turns!".colorize(:cyan)
        break
      end
    end
  end

  def play_game
    puts 'Enter your name:'.colorize(:green)
    human.name = gets.chomp.capitalize
    print "\e[1J\e[H"
    (1..length).each do |j|
      play_round
      @role = (@role + 1) % 2
      rows = []
      human_data = [human.name, human.score]
      computer_data = [computer.name, computer.score]
      rows << human_data
      rows << computer_data
      puts "\nCurrent Scores".colorize(:cyan)
      puts Terminal::Table.new(rows: rows).to_s.colorize(:cyan)
      puts ''
      next if j == length

      puts 'Ready to start the next round? (y/n)'
      if gets.chomp.downcase[0] == 'y'
        print "\e[1J\e[H"
      else
        exit!
      end
    end
    if computer.score > human.score
      puts "\nWonk wonk. The computer beat you #{computer.score.to_s.colorize :magenta} - #{human.score.to_s.colorize :magenta}."
    elsif human.score > computer.score
      puts "\nCongratulations! You beat the computer #{human.score.to_s.colorize :magenta} - #{computer.score.to_s.colorize :magenta}."
    else
      puts "\nHuh. You tied the computer #{human.score.to_s.colorize :magenta} - #{computer.score.to_s.colorize :magenta}"
    end
  end

  def header
    display_header
  end
end

game = Play.new
puts 'Do you know how to play? (y/n)'
unless gets.chomp.downcase[0] == 'y'
  print "\e[1J\e[H"
  game.header
  unless gets.chomp.downcase[0] == 'y'
    puts 'Ok. Goodbye!'
    exit!
  end
end
print "\e[1J\e[H"
game.determine_length
print "\e[1J\e[H"
game.determine_role
print "\e[1J\e[H"
game.play_game
