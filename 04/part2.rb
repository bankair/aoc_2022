# frozen_string_literal: true

require_relative '../assertion'

def perform(input)
  input
    .split
    .map { |line| line.split(/,/).map { |str| Range.new(*str.split(/-/).map(&:to_i)) } }
    .count { |a, b| a.include?(b.begin) || a.include?(b.end) || b.include?(a.begin) || b.include?(a.end) }
end

should_return(4).for do
  perform(<<~INPUT)
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
  INPUT
end

puts perform(File.read('input.txt'))
