# frozen_string_literal: true

require_relative '../assertion'
require 'set'

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def distance(point)
    (x - point.x).abs + (y - point.y).abs
  end

  def eql?(other)
    x == other.x && y == other.y
  end

  def hash
    x + 4_000_000_000 * y
  end
end

class Beacon < Point
end

class Sensor < Point
  attr_reader :beacon

  def initialize(x, y, beacon)
    @beacon = beacon
    super(x, y)
  end

  def out_of_reach_distance
    @out_of_reach_distance ||= distance(beacon) + 1
  end
end

# Map of sensors scopes
class SensorMap
  attr_reader :max_x, :max_y, :sensors

  def initialize(input, max_x, max_y)
    @max_x = max_x
    @max_y = max_y
    @candidates = Set.new
    @sensors = []
    input.split(/\n/).each do |line|
      sensor_x, beacon_x = line.scan(/x=-?\d+/).map { |string| string[2..].to_i }
      sensor_y, beacon_y = line.scan(/y=-?\d+/).map { |string| string[2..].to_i }
      sensors << Sensor.new(sensor_x, sensor_y, Beacon.new(beacon_x, beacon_y))
    end
  end

  def result
    candidates = Set.new
    sensors.each do |sensor|
      distance = sensor.out_of_reach_distance
      (([0, sensor.x - distance].max)..([max_x, sensor.x + distance].min)).each do |x|
        offset = distance - (sensor.x - x).abs
        candidates << Point.new(x, sensor.y + offset) if (0..max_y).include?(sensor.y + offset)
        candidates << Point.new(x, sensor.y - offset) if offset != 1 && (0..max_y).include?(sensor.y - offset)
      end
    end
    candidates.select! do |point|
      sensors.all? { |sensor| sensor.distance(point) >= sensor.out_of_reach_distance }
    end
  end
end

def perform(input, max_x, max_y)
  point = SensorMap.new(input, max_x, max_y).result.first
  4_000_000 * point.x + point.y
end

should_return(56_000_011).for do
  perform(<<~INPUT, 20, 20).tap { |e| puts e }
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
  INPUT
end

puts "Result: #{perform(File.read('input.txt'), 4_000_000, 4_000_000)}"
