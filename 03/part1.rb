# frozen_string_literal: true

require_relative '../assertion'

def perform(input)
  result = 0
  priorities = [nil] + ('a'..'z').to_a + ('A'..'Z').to_a
  input.split.each do |sack|
    items = sack.chars
    middle = items.size / 2
    compartment1 = items[0...middle]
    compartment2 = items[middle..]
    share_item = items.uniq.find { |item| compartment1.include?(item) && compartment2.include?(item) }
    result += priorities.index(share_item)
  end
  result
end

should_return(157).for do
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
