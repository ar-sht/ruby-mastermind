# frozen_string_literal: true

require './feedback'
class Player
  attr_reader :name, :guess

  def initialize(name)
    @name = name
  end
end
