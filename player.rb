require './display'
class Player
  include Display
  attr_accessor :name

  def initialize(name = 'Computer')
    @name = name
  end
end
