require './display'
require 'terminal-table'

class Play
  include Display
  attr_accessor :length, :role, :computer, :human, :name, :feedbacker

  def initialize
    @computer = ComputerPlayer.new
    @human = HumanPlayer.new('Placeholder')
    @feedbacker = Feedback.new
  end

  def set_name
    puts 'Please enter your name:'
    human.name = gets.chomp.capitalize
  end

  def determine_length
    puts 'How many rounds would you like the game to last? Must be an even integer no more than 12:'
    @length = gets.chomp.to_i
    until @length <= 12 && @length.even?
      puts 'Invalid Input. Please try again:'
      @length = gets.chomp.to_i
    end
  end

  def determine_role
    puts "1. Code Maker
2. Code Breaker"
    puts 'Please select one of the above options to play as first'
    @role = gets.chomp.to_i - 1
    until [0, 1].include?(@role)
      puts 'Invalid Input please try again:'
      @role = gets.chomp.to_i - 1
    end
  end

  def play_round
    puts "\n#{"\u25AC" * TERM_WIDTH}"
    if role == 1
      puts 'You are the Code Breaker.'
      puts 'Would you like to play on hard mode? (y/n)'
      hard = gets.chomp.downcase[0] == 'y'
      puts 'Generating code....'
      answer = computer.make_code
      (1..4).each do |_num|
        print " \u2053 ".colorize(:green)
        sleep(0.150)
      end
      puts "\n#{"\u25AC" * TERM_WIDTH}"
      (1..12).each do |i|
        puts "Guess ##{i} of 12:"
        guess = human.make_guess
        display_guess(guess)
        feedback = feedbacker.feedback(answer, guess, false)
        display_result(feedback, hard)
        puts "\u25AC" * TERM_WIDTH
        next unless feedback == [1, 1, 1, 1]

        puts 'Congratulations! You successfully guessed the code'
        puts ''
        display_guess(answer)
        puts "in just #{i} turns!"
        computer.score += i
        break
      end
    else
      puts 'You are the Code Maker.'
      answer = human.make_code
      display_guess(answer)
      puts "\n#{"\u25AC" * TERM_WIDTH}"
      (1..12).each do |i|
        puts "Guess ##{i} of 12:"
        guess = computer.make_guess(answer)
        display_computer_guess(guess)
        feedback = feedbacker.feedback(answer, guess, false)
        display_result(feedback, true)
        puts "\u25AC" * TERM_WIDTH
        sleep(0.500)
        next unless feedback == [1, 1, 1, 1]

        puts 'Dang! The computer guessed your code'
        puts ''
        display_guess(answer)
        puts "in just #{i} turns!"
        human.score += i
        break
      end
    end
  end

  def play_game
    puts 'Enter your name:'
    human.name = gets.chomp.capitalize
    (1..length).each do |j|
      play_round
      @role = (@role + 1) % 2
      rows = []
      human_data = [human.name, human.score]
      computer_data = [computer.name, computer.score]
      rows << human_data
      rows << computer_data
      puts 'Current Scores'
      puts Terminal::Table.new(rows: rows)
    end
    if computer.score > human.score
      puts "Wonk wonk. The computer beat you #{computer.score}-#{human.score}."
    elsif human.score > computer.score
      puts "Congratulations! You beat the computer #{human.score}-#{computer.score}."
    else
      puts "Huh. You tied the computer #{human.score}-#{computer.score}"
    end
  end

  def header
    display_header
  end
end

game = Play.new
puts 'Do you need a refresher on the rules of the game? (y/n)'
unless gets.chomp.downcase[0] == 'n'
  game.header
  unless gets.chomp.downcase[0] == 'y'
    puts 'Ok. Goodbye!'
    exit!
  end
end
print "\e[1J\e[H"
game.determine_length
game.determine_role
game.play_game
