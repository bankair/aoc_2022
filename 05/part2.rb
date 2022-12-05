# frozen_string_literal: true

require_relative '../assertion'

# Parse the moves
class MoveParser
  def self.parse!(line, stacks)
    return self if line.empty?

    quantity, origin, dest = line.split.map(&:to_i).select(&:positive?)
    stacks[dest - 1] += stacks[origin - 1].pop(quantity)
    self
  end
end

# Parse the stacks
class StackParser
  def self.parse!(line, stacks)
    return MoveParser if line =~ /^ 1/

    stacks.size.times do |index|
      value = line[4 * index + 1]
      stacks[index].unshift(value) unless value == ' '
    end
    self
  end
end

def parse(input)
  parser = StackParser
  lines = input.split(/\n/)
  columns = (lines.first.size + 1) / 4
  stacks = columns.times.map { [] }
  lines.each do |line|
    parser = parser.parse!(line, stacks)
  end
  stacks.map(&:last).join
end

def perform(input)
  parse(input)
end

should_return('MCD').for do
  perform(<<-INPUT)
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
  INPUT
end

puts perform(File.read('input.txt'))
