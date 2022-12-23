# frozen_string_literal: true

require_relative '../assertion'
require 'set'

# Map of sensors scopes
class SensorMap
  attr_accessor :scanned

  def initialize(input, target_row)
    @scanned = Set.new
    input.split(/\n/).each do |line|
      sensor_x, beacon_x = line.scan(/x=-?\d+/).map { |string| string[2..].to_i }
      sensor_y, beacon_y = line.scan(/y=-?\d+/).map { |string| string[2..].to_i }
      distance = (sensor_x - beacon_x).abs + (sensor_y - beacon_y).abs

      y_distance = (sensor_y - target_row).abs
      next if y_distance > distance

      remaining = distance - y_distance
      self.scanned += ((sensor_x - remaining)..(sensor_x + remaining)).to_a
    end
  end
end

def perform(input, y)
  SensorMap.new(input, y).scanned.size - 1
end

should_return(26).for do
  perform(<<~INPUT, 10).tap { |e| puts e }
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

puts "Result: #{perform(File.read('input.txt'), 2000000)}"
