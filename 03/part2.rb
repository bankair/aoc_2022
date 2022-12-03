# frozen_string_literal: true

require_relative '../assertion'

PRIORITIES = ([nil] + ('a'..'z').to_a + ('A'..'Z').to_a).freeze

def priority(item)
  PRIORITIES.index(item)
end

def common_item(sacks)
  sacks.reduce(&:&).first
end

def perform(input)
  input.split.each_slice(3).map { |lines| priority(common_item(lines.map(&:chars))) }.sum
end

should_return(70).for do
  perform(<<~INPUT)
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
  INPUT
end

puts perform(File.read('input.txt'))
