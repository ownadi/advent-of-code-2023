RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

$instructions = nil
$network = {}

File.foreach('input').each_with_index do |line, line_idx|
  if line_idx.zero?
    $instructions = line.chars[0..-2].cycle
    next
  end

  source, left, right = line.scan(/(.{3}) = \((.{3}), (.{3})\)/).first

  $network[source] = [left, right]
end

eval <<~RUBY
def find_pattern(pattern, element = 'AAA', idx = 0)
  $instructions.rewind if idx.zero?

  return idx if element.match?(pattern)

  find_pattern(pattern, $network[element][$instructions.next == 'L' ? 0 : 1], idx.succ)
end
RUBY

def find_patterns(pattern = /^..Z$/, elements = $network.keys.compact.select {_1[-1] == 'A'}, idx = 0)
  current_instruction = $instructions.next

  result = elements.map { find_pattern(pattern, _1) }

  result.inject(&:lcm)
end

puts find_pattern(/^ZZZ$/)
puts find_patterns
