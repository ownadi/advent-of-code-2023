class History
  def self.from_line(line)
    new(line.split.map(&:to_i))
  end

  attr_accessor :values

  def initialize(values)
    @values = values
    @diffs = []
  end

  def next
    diffs.last.push(0)

    diffs.reverse_each.each_cons(2) do |(last_set, next_set)|
      next_set.push(next_set.last + last_set.last)
    end

    (values.last + diffs.first.last).tap { @values.push(_1) }
  end

  def prev
    diffs.last.unshift(0)

    diffs.reverse_each.each_cons(2) do |(last_set, next_set)|
      next_set.unshift(next_set.first - last_set.first)
    end

    (values.first - diffs.first.first).tap { @values.unshift(_1) }
  end

  def diffs
    @diffs.empty? ? find_diffs : @diffs
  end

  private

  def find_diffs
    current = @diffs.last || values
    current_diffs =  current.each_cons(2).map { _2 - _1 }
    @diffs << current_diffs

    current_diffs.all?(&:zero?) ? @diffs : find_diffs
  end
end

puts File.foreach('input').map { History.from_line(_1) }.each_with_object([0, 0]) { _2[0] += _1.next; _2[1] += _1.prev }
