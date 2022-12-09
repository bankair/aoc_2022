# frozen_string_literal: true

require_relative '../assertion'
require 'set'
require 'byebug'

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

    if x == position.x
      @y = position.previous_y
    elsif y == position.y
      @x = position.previous_x
    else
      @x += position.x > x ? 1 : -1
      @y += position.y > y ? 1 : -1
    end
  end
end

def perform(input)
  visited = Set.new
  head = Position.new
  tails = Array.new(9) { Position.new }

  input.split(/\n/).each do |line|
    direction, steps = line.split
    steps.to_i.times do
      head.move!(direction)
      preceding = head
      tails.each do |tail|
        tail.follow!(preceding)
        preceding = tail
      end
      visited << [preceding.x, preceding.y]
    end
  end

  visited.size
end

should_return(1).for do
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

should_return(36).for do
  perform(<<~INPUT)
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
  INPUT
end

puts perform(File.read('input.txt'))
