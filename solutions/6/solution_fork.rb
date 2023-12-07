require 'etc'

CPUS = Etc.nprocessors

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
  processes = time > 100 ? CPUS : 1

  time_fraction = time / processes
  time_reminder = time % processes

  pids = []
  readers = []

  processes.times do |cpu|
    reader, writer = IO.pipe
    readers << reader

    pids << fork do
      reader.close

      res = 0

      ((time_fraction) * cpu).upto(time_fraction * cpu.succ + (cpu == processes.pred ? time_reminder : -1)) do |t|
        if (time - t) * t > distance
          res += 1
        elsif res.positive?
          break
        end
      end

      writer.write(res.to_s)
      writer.close
      exit
    end

    writer.close
  end

  pids.each { Process.wait(_1) }
  readers.reduce(0) { _1 + _2.read.to_i }
end

puts results[0..-2].inject(:*)
puts results[-1]
