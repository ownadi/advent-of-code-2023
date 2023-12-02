numbers1 = []
numbers2 = []

DIGITS = Hash.new { |h, k| h[k] = k.to_i }
DIGITS.merge!(
  'zero' => 0,
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9,
)

puts DIGITS

File.foreach('input') do
  scanned_digits = _1.scan(/\d/)
  numbers1 << scanned_digits.first.to_i * 10 + scanned_digits.last.to_i

  scanned_digits = _1.scan(/(?=(#{DIGITS.keys.join('|')}|\d))/).flatten
  numbers2 << DIGITS[scanned_digits.first] * 10 + DIGITS[scanned_digits.last]
end

puts numbers1.sum
puts numbers2.sum
