# frozen_string_literal: true
class Feedback
  attr_accessor :feedback_hash, :feedback_arr, :code, :guess

  def feedback(code, guess, hard, computer)
    @feedback_arr = []
    @feedback_hash = {
      matches: 0,
      partials: 0
    }
    @code = code
    @guess = guess
    eliminate_positions
    if computer
      feedback_hash
    elsif hard
      feedback_arr.shuffle
    else
      feedback_arr
    end
  end

  private

  def eliminate_positions
    matches
    partials
  end

  def delete_indexes(indexes, array)
    array.reject!.with_index { |_value, index| indexes.include? index }
  end

  def matches
    to_delete = []
    @code.each_with_index do |_val, index|
      unless @code[index] == @guess[index]
        feedback_arr[index] = -1
        next
      end

      feedback_arr[index] = 1
      feedback_hash[:matches] += 1
      to_delete << index
    end
    delete_indexes(to_delete, @code)
    delete_indexes(to_delete, @guess)
  end

  def partials
    @code.each do |val|
      next unless @guess.include?(val)

      @code.delete_at(@code.find_index(val))
      feedback_arr[@guess.find_index(val)] = 0
      feedback_hash[:partials] += 1
    end
  end
end
