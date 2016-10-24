class Errors

  attr_accessor :all

  def initialize
    self.all = []
  end

  def add(symbol, string)
    all << [symbol, string]
  end

  def clear 
    all.clear
  end

end