class EngineToken
  GEAR_SYMBOL = '*'

  attr_reader :token, :start_pos, :end_pos, :line, :adjacent_numbers

  def initialize(token, line, start_pos)
    @token = token
    @token = @token.to_i if @token.match?(/^\d+$/)
    @line = line
    @start_pos = start_pos
    @end_pos = start_pos + token.length - 1
    @part_number = false
    @adjacent_numbers = Set.new
  end

  def part_number?
    @part_number
  end

  def check_symbol!(token)
    return true if part_number?
    return false if symbol?
    return false if !token.symbol?

    result = (line == token.line && (start_pos.pred == token.start_pos || end_pos.succ == token.end_pos) ) ||
      ((line == token.line.pred || line == token.line.succ) && ((start_pos.pred..end_pos.succ).include?(token.start_pos)))

    result.tap do
      @part_number = _1
      token.adjacent_numbers << self if _1
    end
  end

  def number?
    token.is_a?(Integer)
  end

  def symbol?
    !number?
  end

  def gear?
    token == GEAR_SYMBOL && adjacent_numbers.size == 2
  end

  def gear_ratio
    return 0 unless gear?

    adjacent_numbers.map(&:token).inject(:*)
  end
end

class EngineTokens
  attr_reader :numbers, :symbols

  class << self
    def from_file(file)
      new.tap do |instance|
        lines = File.foreach(file).each_with_index do |line, line_idx|
          line.scan(/\d+|[^.\d\s]/) do |match|
            instance.build(match, line_idx, Regexp.last_match.begin(0))
          end
        end
      end
    end
  end

  def initialize
    @numbers = []
    @symbols = []
  end

  def build(str, line, start_pos)
    token = EngineToken.new(str, line, start_pos)
    if token.number?
      @numbers << token
    else
      @symbols << token
    end

    self
  end

  def validate!
    symbols.each do |symbol|
      numbers.each { |number| number.check_symbol!(symbol) }
    end
  end

  def gears
    symbols.select(&:gear?)
  end

  def part_numbers
    numbers.select(&:part_number?)
  end
end

tokens = EngineTokens.from_file('input')
tokens.validate!

puts tokens.part_numbers.sum(&:token)
puts tokens.gears.sum(&:gear_ratio)
