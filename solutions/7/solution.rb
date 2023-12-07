class Hand
  include Comparable

  attr_reader :cards, :original_cards

  MAP = Hash.new { |h, k| h[k] = k.to_i }
  MAP.merge!('T' => 10, 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14)

  def initialize(cards)
    @cards = cards
    @original_cards = cards
    @map = MAP
  end

  def type
    @type ||= begin
      same_cards = cards.chars.group_by(&:itself).transform_values(&:count).values.select { _1 > 1 }
      (same_cards.max.to_i << 4) + same_cards.sum
    end
  end

  def order
    @order ||= [*original_cards.chars, 0, 0, 0].map { @map[_1] }.pack('C*').unpack1('Q>')
  end

  def <=>(other)
    return type <=> other.type if type != other.type

    order <=> other.order
  end

  def jokerize!
    @type = nil
    @order = nil

    @map = MAP.merge('J' => 1)

    the_best_card = cards.chars.group_by(&:itself).values.max_by { _1.first == 'J' ? 0 : _1.size }.first
    @cards = cards.gsub('J', the_best_card)
  end
end

class Game
  attr_reader :hands

  def initialize
    @hands = []
  end

  def add_hand(cards, bid)
    hands << [Hand.new(cards), bid.to_i]
  end

  def total_winnings
    hands.sort_by(&:first).each.with_index(1).reduce(0) do |total, ((_hand, bid), index)|
      total += bid * index
    end
  end

  def jokerize!
    hands.each { _1.first.jokerize! }
  end
end

game = Game.new

File.foreach('input') do |line|
  hand, bid = line.scan(/(.{5}) (\d+)/).first
  game.add_hand(hand, bid)
end

puts game.total_winnings
game.jokerize!
puts game.total_winnings
