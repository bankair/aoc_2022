# frozen_string_literal: true

require_relative '../assertion'
require 'set'

class Position
  attr_reader :x, :y, :previous_x, :previous_y

  def initialize(x = 0, y = 0)
    @x = x
    @previous_x = x
    @y = y
    @previous_y = y
  end

  def adjacent?(position)
    (x - position.x).abs < 2 && (y - position.y).abs < 2
  end

  def move!(direction)
    @previous_x = x
    @previous_y = y
    offset = {
      'U' => [0, 1],
      'L' => [-1, 0],
      'R' => [1, 0],
      'D' => [0, -1]
    }[direction]
    @x = x + offset.first
    @y = y + offset.last
  end

  def follow!(position)
    return if adjacent?(position)

    @previous_x = x
    @previous_y = y

    @x = position.previous_x
    @y = position.previous_y
  end
end

def perform(input)
  visited = Set.new
  head = Position.new
  tail = Position.new

  input.split(/\n/).each do |line|
    direction, steps = line.split
    steps.to_i.times do
      head.move!(direction)
      tail.follow!(head)
      visited << [tail.x, tail.y]
    end
  end
  visited.size
end

should_return(true).for { Position.new(1, 1).adjacent?(Position.new(1, 1)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(0, 0)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(0, 1)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(0, 2)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(1, 0)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(1, 2)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(2, 0)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(2, 1)) }
should_return(true).for { Position.new(1, 1).adjacent?(Position.new(2, 2)) }

should_return(13).for do
  perform(<<~INPUT)
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
  INPUT
end

puts perform(File.read('input.txt'))
