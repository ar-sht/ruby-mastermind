# frozen_string_literal: true

require './answer'
require 'colorize'
# require './sequence'

puts "1. Guess a computer-generated code
2. Create your own code and see how the computer does\n
Please type 1 or 2 to choose one of the above options."

comp_answer = false
until comp_answer
  comp_answer = gets.chomp.to_i == 1
  puts 'Sorry, this feature is not supported yet. Please choose option 1' unless comp_answer
end

if comp_answer
  answer = Answer.new
else
  puts 'Enter your code with 4 numbers 1-6 with a space between each'
  answer = Answer.new(gets.chomp.split)
end

puts 'Would you like to play on hard mode? (y/n)'
hard_mode = gets.chomp.downcase[0] == 'y'

result_key = {
  1 => "\u25A0".colorize(:green),
  0 => "\u25A0".colorize(:yellow),
  -1 => "\u25A0"
}
guess = Sequence.new([0] * 4)
(1..12).each do |i|
  puts "Please enter guess ##{i} in the format of 4 numbers 1-6 with a space between each:"
  guess = Sequence.new(gets
                         .chomp
                         .split
                         .map(&:to_i))
  puts "Your guess was: #{guess.key.join(' ')}"
  print 'The result was: '
  if hard_mode
    puts answer
      .match(guess)
      .shuffle
      .map { |result| result_key[result] }
      .join(' ')
  else
    puts answer
      .match(guess)
      .map { |result| result_key[result] }
      .join(' ')
  end
  break if answer.match(guess) == [1, 1, 1, 1]
end
if answer.match(guess)
  puts 'You got the code right! Congrats!'
elsif hard_mode
  puts "Tough luck. Hopefully you'll get it next time!"
else
  puts "Wonk Wonk. You couldn't get it right even in 12 turns! You suck!"

end
