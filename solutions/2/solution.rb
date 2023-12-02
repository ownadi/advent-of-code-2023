AMOUNTS = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

ids = []
powers = []

File.foreach('input') do
  grouped = _1.scan(/(\d+) ([a-z]*)/)
    .group_by(&:last)
    .map { |k, v| [k, v.map { |v| v.first.to_i }.max] }
    .to_h

  if AMOUNTS.none? { |(color, amount)| grouped[color] > amount }
     ids << _1.match(/^Game (\d+):/)[1].to_i
  end

  powers << grouped.values.inject(:*)
end

puts ids.sum
puts powers.sum
