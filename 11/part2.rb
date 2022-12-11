# frozen_string_literal: true

require_relative '../assertion'
require 'byebug'

$debug = false

# That damn monkeys...
class Monkey
  attr_reader :items, :operation, :modulo, :targets
  attr_accessor :inspections

  def initialize(description)
    lines = description.split(/\n/).reject(&:empty?)
    @items = lines[1].scan(/\d+/).map(&:to_i)
    @operation = lines[2][19..].gsub('old', 'item')
    @modulo = lines[3][/\d+/].to_i
    @targets = { true => lines[4][/\d+/].to_i, false => lines[5][/\d+/].to_i }
    @inspections = 0
  end

  def inspect(item)
    eval(operation)
  end

  def target(item)
    divisible = (item % modulo).zero?
    targets[divisible]
  end
end

def perform(input)
  monkeys = input.split(/^$/).map { |description| Monkey.new(description) }
  lcm = monkeys.map(&:modulo).reduce(:lcm)
  10_000.times do
    monkeys.each do |monkey|
      monkey.inspections += monkey.items.size
      loop do
        item = monkey.items.shift || break
        item = monkey.inspect(item) % lcm
        monkeys[monkey.target(item)].items << item
      end
    end
  end
  monkeys.map(&:inspections).max(2).reduce(:*)
end

should_return(2_713_310_158).for do
  perform(<<~INPUT)
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
  INPUT
end

puts perform(File.read('input.txt'))
