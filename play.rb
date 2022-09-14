# frozen_string_literal: true

require './answer'
require 'colorize'
require './guesser'

puts "WELCOME TO MASTERMIND"
answer = Answer.new
puts 'Enter your name: '
player = Guesser.new(gets.chomp)

puts "Ok then, #{player.name}. Would you like to play on hard mode? (y/n)"
hard_mode = gets.chomp.downcase[0] == 'y'

result_key = {
  1 => "\u25A0".colorize(:green),
  0 => "\u25A0".colorize(:yellow),
  -1 => "\u25A0"
}
(1..12).each do |i|
  puts "Please enter guess ##{i} in the format of 4 numbers 1-6 with a space between each:"
  player.make_guess
  puts "Your guess was: #{player.guess.key.join(' ')}"
  print 'The result was: '
  if hard_mode
    puts answer
      .match(player.guess)
      .shuffle
      .map { |result| result_key[result] }
      .join(' ')
  else
    puts answer
      .match(player.guess)
      .map { |result| result_key[result] }
      .join(' ')
  end
  if answer.match(player.guess) == [1, 1, 1, 1]
    puts "You got it right! Congrats!\nIt took you #{i} turns to guess the code #{answer.key.join(' ')}!"
    break
  end
end
if  answer.match(player.guess) != [1, 1, 1, 1]
  if hard_mode
    puts "Tough luck. Hopefully you'll get it next time!"
  elsif answer.match(player.guess) != [1, 1, 1, 1]
    puts "Wonk Wonk. You couldn't get it right even in 12 turns!\n#{'You suck!'.colorize(:red)}"
  end
end
