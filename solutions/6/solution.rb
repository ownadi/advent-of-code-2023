results = nil

File.foreach('input') do |line|
  scanned = line.scan(/\d+/)

  if !results
    results =  scanned.map(&:to_i)
    results << scanned.join.to_i

    next
  end

  results = results.zip(scanned.map(&:to_i) + [scanned.join.to_i])
end

results = (results).map do |(time, distance)|
  res = 0

  time.times do |t|
    if (time - t.succ) * t.succ > distance
      res += 1
    elsif res.positive?
      break
    end
  end

  res
end

puts results[0..-2].inject(:*)
puts results[-1]
