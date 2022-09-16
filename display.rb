# frozen_string_literal: true
module Display
  require 'colorize'
  require 'pry-byebug'
  require './human_player'
  require './computer_player'
  require './feedback'
  require 'tty-screen'

  TERM_WIDTH = TTY::Screen.width
  GUESS_KEY = {
    1 => ' 1 '.colorize(color: :light_white, background: :red),
    2 => ' 2 '.colorize(color: :light_white, background: :yellow),
    3 => ' 3 '.colorize(color: :light_white, background: :green),
    4 => ' 4 '.colorize(color: :light_white, background: :cyan),
    5 => ' 5 '.colorize(color: :light_white, background: :magenta),
    6 => ' 6 '.colorize(color: :light_white, background: :light_black)
  }.freeze

  RESULT_KEY = {
    1 => " \u25CF ".colorize(:cyan),
    0 => " \u25CB ".colorize(:cyan),
    -1 => '   '
  }.freeze

  def display_header
    player = HumanPlayer.new('Example')
    computer = ComputerPlayer.new
    feedbacker = Feedback.new
    puts "The rules of the game are as follows:\n\n".colorize(:cyan)
    puts 'You will play an even number of games against the computer, alternating between creating a code and guessing one.'.colorize(:cyan)
    puts 'The winner will be the one who takes the shortest amount of time to guess the codes.'.colorize(:cyan)
    puts "\nIn each round, the code maker will create a code in the form of four whole numbers that looks like this:\n ".colorize(:cyan)
    ex_answer = computer.make_code
    display_guess(ex_answer)
    puts "\n\nThe code breaker will guess the code in the same format with integers up to 6.\n".colorize(:cyan)
    ex_guess = player.make_guess
    display_guess(ex_guess)
    feedback = feedbacker.feedback(ex_answer, ex_guess, false)
    display_result(feedback)
    puts "\u2191 This is the feedback the guesser receives".colorize(:cyan)
    puts "#{RESULT_KEY[1]} means the number is in the correct position and #{RESULT_KEY[0]} means the number is in the code but in the wrong position.".colorize(:cyan)
    puts "\nIf you're playing on hard mode your feedback will just look like this (the computer always plays on hard mode):\n".colorize(:cyan)
    display_result(feedback, true)
    puts "\nReady to start? (y/n)".colorize(:green)
  end

  def display_guess(arr)
    colored_arr = arr.map { |num| GUESS_KEY[num] }
    print "\r\e[A\e[K"
    puts colored_arr.join(' ')
  end

  def display_computer_guess(arr)
    # print "\e[A"
    colored_arr = arr.map { |num| GUESS_KEY[num] }
    colored_arr.each do |str|
      print " \u2053 ".colorize(:green)
      sleep(0.100)
      print "\e[D\e[D\e[D"
      print "#{str} "
    end
    puts ''
  end

  def display_result(arr, hard = false)
    num_matches = arr.reduce(0) { |total_matches, num| num == 1 ? total_matches + 1 : total_matches }
    num_partials = arr.reduce(0) { |total_partials, num| num.zero? ? total_partials + 1 : total_partials }
    marked_arr = arr.map { |num| RESULT_KEY[num] }
    marked_hash = {
      'Number in correct position'.colorize(:cyan) => num_matches,
      'Number in wrong Position'.colorize(:cyan) => num_partials
    }
    if hard
      marked_hash.each { |key, val| puts "#{key}: #{val}".colorize(:cyan) }
    else
      puts marked_arr.join(' ')
    end
  end
end
