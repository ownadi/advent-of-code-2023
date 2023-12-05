class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

class SubjectMap
  class Range
    def initialize(destination_range_start, source_range_start, range_length)
      @destination_range_start = destination_range_start
      @source_range_start = source_range_start
      @range_length = range_length
    end

    def include?(idx)
      range.overlaps?(idx)
    end

    def [](idx)
      first_result = [idx.first, range.first].max - @source_range_start + @destination_range_start
      last_result = [idx.last, range.last].min - @source_range_start + @destination_range_start

      first_result..last_result
    end

    def range
      @range ||= @source_range_start..(@source_range_start + @range_length)
    end
  end

  def initialize
    @ranges = []
  end

  def [](idx)
    ranges = @ranges.select { _1.include?(idx) }
    return [idx] if ranges.none?

    ranges.map { _1[idx] }
  end

  def add_range(destination_range_start, source_range_start, range_length)
    @ranges << Range.new(destination_range_start, source_range_start, range_length)
  end

  def any?
    @ranges.any?
  end
end

seeds = nil
seed_ranges = nil
subject_map = SubjectMap.new

File.foreach('input').each_with_index do |line, idx|
  if idx.zero?
    seeds = line.scan(/\d+/).map { _1.to_i.._1.to_i }
    seed_ranges = seeds.each_slice(2).map { |(a, b)| (a.first..(a.first+b.first)) }
    next
  end

  next if line[-5..-2] == "map:"

  if line == "\n"
    if subject_map.any?
      seeds = seeds.flat_map do |seed|
        subject_map[seed]
      end

      seed_ranges = seed_ranges.flat_map do |seed_range|
        subject_map[seed_range]
      end
    end

    subject_map = SubjectMap.new
    next
  end

  subject_map.add_range(*line.scan(/\d+/).map(&:to_i))
end

puts seeds.map(&:first).min
puts seed_ranges.map(&:first).min
