# frozen_string_literal: true

require_relative '../assertion'

Position = Struct.new(:x, :y) do
  def inspect
    "#<Position x=#{x}, y=#{y}>"
  end
end

# Represent the cave
class Cave
  attr_reader :min_x, :min_y, :max_x, :max_y, :elements

  SAND = :sand
  ROCK = :rock

  def initialize(paths)
    @elements = Hash.new { |hash, x| hash[x] = {} }
    @min_x = @min_y = Float::INFINITY
    @max_x = @max_y = -Float::INFINITY
    paths.each do |path|
      positions = path.split(/ -> /).map { |string| Position.new(*string.split(/,/).map(&:to_i)) }
      loop do
        current_position = positions.shift
        next_position = positions.first || break
        pair = [current_position, next_position]
        local_min_x, local_max_x = pair.map(&:x).sort
        local_min_y, local_max_y = pair.map(&:y).sort

        # Register global mins and maxes
        @min_x = local_min_x if local_min_x < @min_x
        @min_y = local_min_y if local_min_y < @min_y
        @max_x = local_max_x if local_max_x > @max_x
        @max_y = local_max_y if local_max_y > @max_y

        (local_min_x..local_max_x).each do |x|
          (local_min_y..local_max_y).each do |y|
            elements[x][y] = ROCK
          end
        end
      end
    end
  end

  def fill_up_with_sand!
    units = 0
    position = Position.new(500, 0)
    loop do
      floor = elements[position.x].keys.select { |y| position.y < y }.min
      return units unless floor

      if elements[position.x - 1][floor].nil?
        position.x += -1
        position.y = floor - 1
      elsif elements[position.x + 1][floor].nil?
        position.x += 1
        position.y = floor - 1
      else
        elements[position.x][floor - 1] = SAND
        position = Position.new(500, 0)
        units += 1
      end
    end
  end

  def to_s
    (min_y..max_y).map do |y|
      (min_x..max_x).map do |x|
        tile = @elements.fetch(x, {})[y]
        { SAND => 'o', ROCK => '#' }.fetch(tile, '.')
      end.join
    end.join("\n")
  end
end

def perform(input)
  cave = Cave.new(input.split(/\n/))
  cave.fill_up_with_sand!
end

should_return(24).for do
  perform(<<~INPUT)
    498,4 -> 498,6 -> 496,6
    503,4 -> 502,4 -> 502,9 -> 494,9
  INPUT
end

puts perform(File.read('input.txt'))
