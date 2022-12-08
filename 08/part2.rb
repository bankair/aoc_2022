# frozen_string_literal: true

require_relative '../assertion'

require 'set'

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

  def score(x, y)
    value = three_rows[y][x]
    result = 1

    xx = x
    yy = y
    distance = 1
    loop do
      yy -= 1
      break if y.zero? || yy <= 0 || three_rows[yy][xx] >= value

      distance += 1
    end
    result *= distance
    xx = x
    yy = y
    distance = 1
    loop do
      yy += 1
      break if yy >= height - 1 || three_rows[yy][xx] >= value

      distance += 1
    end
    result *= distance
    xx = x
    yy = y
    distance = 1
    loop do
      xx -= 1
      break if xx <= 0 || three_rows[yy][xx] >= value

      distance += 1
    end
    result *= distance
    xx = x
    yy = y
    distance = 1
    loop do
      xx += 1
      break if xx >= width - 1 || three_rows[yy][xx] >= value

      distance += 1
    end
    result *= distance
    result
  end
end

def perform(input)
  grid = Grid.new(input.split(/\n/))
  max_score = 0
  max_pos = nil
  puts grid.score(2, 1)
  (0...grid.height).each do |y|
    (0...grid.width).each do |x|
      three_score = grid.score(x, y)
      if three_score > max_score
        max_score = three_score
        max_pos = [x,y]
      end
    end
  end
  puts max_pos.inspect
  max_score
end

should_return(16).for do
  perform(<<~INPUT)
    30373
    25512
    65332
    33549
    35390
  INPUT
end

puts perform(File.read('input.txt'))
