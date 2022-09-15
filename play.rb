# frozen_string_literal: true

require 'colorize'
require './computer_player'
require './human_player'
require 'pry-byebug'

result_key = {
  1 => " \u25CF ",
  0 => " \u25CB ",
  -1 => " \u2A2F "
}

num_key = {
  1 => ' 1 '.colorize(color: :light_white, background: :red),
  2 => ' 2 '.colorize(color: :light_white, background: :yellow),
  3 => ' 3 '.colorize(color: :light_white, background: :green),
  4 => ' 4 '.colorize(color: :light_white, background: :light_blue),
  5 => ' 5 '.colorize(color: :light_white, background: :magenta),
  6 => ' 6 '.colorize(color: :light_white, background: :light_black)
}

puts "WELCOME TO MASTERMIND\nThe form used for codes here looks like this:"
num_key.each { |_key, val| print val.to_s }

puts "\nAnd the you'll receive feedback for your guesses like this:"
print "Number is in the code AND in the correct place: #{result_key[1]}
Number is in the code but in the WRONG place: #{result_key[0]}
Number is NOT in the code: #{result_key[-1]}"

puts "\n\n1. Make a code\n2. Guess a code\nPick one of the above options:"

player_guess = gets.chomp.to_i == 2

computer = ComputerPlayer.new
puts 'Enter your name: '
player = HumanPlayer.new(gets.chomp)
feedbacker = Feedback.new
if player_guess
  answer = computer.make_code
  puts "Ok then, #{player.name}. Would you like to play on hard mode? (y/n)"
  hard_mode = gets.chomp.downcase[0] == 'y'
  (1..12).each do |i|
    puts "#{'=' * 80}\nGuess ##{i}"
    cur_guess = player.make_guess
    print "\r\e[A\e[K"
    puts cur_guess.map { |val| num_key[val] }.join
    # binding.pry
    puts feedbacker.feedback(answer, cur_guess, hard_mode, false).map { |val| result_key[val] }.join
    if feedbacker.feedback(answer, cur_guess, hard_mode, false) == [1, 1, 1, 1]
      puts "Congratulations! You guessed the code in #{i} turns"
      break
    end
  end
  if hard_mode
    puts "Tough luck, the code was #{answer.map { |val| num_key[val] }.join}."
  else
    puts "Wow, you lost on easy mode. #{'You really suck!'.colorize(:red)} The code was #{answer.map do |val|
                                                                                            num_key[val]
                                                                                          end.join}"
  end
else
  answer = player.make_code
  computer.make_guess(nil)
  (1..12).each do |i|
    feedback = feedbacker.feedback(answer, computer.guess.guess, true, true)
    computer.make_guess(feedback)
    if computer.guess == answer
      puts "Done, code was #{answer}"
      break
    end
  end
end
