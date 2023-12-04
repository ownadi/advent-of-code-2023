total_points = 0
cards = Hash.new(0)

File.foreach('input').each_with_index do |line, line_idx|
  cards[line_idx] += 1

  scanned = line.scan(/(?:: |\G(?!\A))[\s|]*(\d+)/).flatten
  matches = scanned.length - scanned.uniq.length
  next if matches.zero?

  (line_idx.succ..(line_idx + matches)).each do |idx|
    cards[idx] += cards[line_idx]
  end

  total_points += (2 ** matches.pred)
end

puts total_points
puts cards.values.sum
