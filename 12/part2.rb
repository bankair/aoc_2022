# frozen_string_literal: true

require_relative '../assertion'
require 'set' 
require 'byebug'

# Position on the map
class Node
  attr_reader :children, :height

  def initialize(height)
    @height = height
    @children = Set.new
  end

  def check_neighbor!(other)
    children << other if height + 1 >= other.height
  end
end

# Map
class Grid
  attr_reader :end_node, :grid, :per_height

  def initialize(lines)
    @per_height = Array.new(26) { [] }
    @grid = lines.map do |line|
      line.chars.map do |char|
        height = { 'S' => 0, 'E' => 25 }.fetch(char) { char.ord - 97 }
        node = Node.new(height)
        @start_node = node if char == 'S'
        @end_node = node if char == 'E'
        per_height[height] << node
        node
      end
    end
    grid.each_with_index do |line, y|
      line.each_with_index do |node, x|
        node.check_neighbor!(grid[y - 1][x]) if y.positive?
        node.check_neighbor!(grid[y + 1][x]) if y < grid.size - 1
        node.check_neighbor!(grid[y][x - 1]) if x.positive?
        node.check_neighbor!(grid[y][x + 1]) if x < grid[0].size - 1
      end
    end
  end

  def calculate_distance
    candidates = Set.new
    grid.each { |line| line.each { |node| candidates << node if node.height.zero? } }
    distance = 0
    visited = Set.new
    loop do
      return distance if candidates.include?(@end_node)

      visited += candidates
      next_candidates = Set.new
      candidates.each { |candidate| next_candidates += candidate.children - visited }
      candidates = next_candidates
      distance += 1
    end
  end
end

def perform(input)
  grid = Grid.new(input.split(/\n/))
  grid.calculate_distance
end

should_return(29).for do
  perform(<<~INPUT)
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
  INPUT
end

puts perform(File.read('input.txt'))
