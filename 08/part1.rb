# frozen_string_literal: true

require_relative '../assertion'

require 'set'
require 'byebug'

# Threes grid
class Grid
  attr_reader :three_rows

  def initialize(lines)
    @three_rows = lines.map { |line| line.chars.map(&:to_i) }
  end

  def width
    @width ||= three_rows.first.size
  end

  def height
    @height ||= three_rows.size
  end
end

def perform(input)
  grid = Grid.new(input.split(/\n/))
  visibles = Set.new

  (0..(grid.height - 1)).each do |y|
    last = -1
    (0..(grid.width - 1)).each do |x|
      position = [x, y]

      three = grid.three_rows[y][x]
      if last < three
        visibles << position
        last = three
      end

      break if last == 9
    end

    last = -1
    (1..grid.width).each do |x_offset|
      x = grid.width - x_offset
      position = [x, y]

      three = grid.three_rows[y][x]
      if last < three
        visibles << position
        last = three
      end

      break if last == 9
    end
  end

  (0..(grid.width - 1)).each do |x|
    last = -1
    (0..(grid.height - 1)).each do |y|
      position = [x, y]

      three = grid.three_rows[y][x]
      if last < three
        visibles << position
        last = three
      end

      break if last == 9
    end

    last = -1
    (1..grid.height).each do |y_offset|
      y = grid.height - y_offset
      position = [x, y]

      three = grid.three_rows[y][x]
      if last < three
        visibles << position
        last = three
      end

      break if last == 9
    end
  end

  visibles.size
end

should_return(21).for do
  perform(<<~INPUT)
    30373
    25512
    65332
    33549
    35390
  INPUT
end

puts perform(File.read('input.txt'))
