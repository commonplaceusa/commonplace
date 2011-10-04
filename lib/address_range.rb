class AddressRange

  # String format is /\d+/ or /\d+-\d+(E|O)?/
  def initialize(string)
    self.string = string
  end

  attr_accessor :string
  
  def each(&block)
    range.each &block
  end

  def range
    if is_range?
      first,last = string.split("-").map(&:to_i)
    else
      first = last = string.to_i
    end

    (first..last).select {|i| i.odd? ? keep_odds? : keep_evens? }
  end

  def is_range?
    string.include?("-")
  end

  def keep_odds?
    !string.include?("E")
  end

  def keep_evens?
    !string.include?("O")
  end
end
