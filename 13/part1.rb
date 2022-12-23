# frozen_string_literal: true

require_relative '../assertion'

def proper_order?(left, right)
  # Hack for Array#zip not padding left missing values
  left += [nil] * (right.size - left.size) if right.size > left.size

  left.zip(right).each do |lval, rval|
    return true if lval.nil?
    return false if rval.nil?

    if rval.is_a?(Integer) && lval.is_a?(Integer)
      return (lval < rval) unless rval == lval
    else
      result = proper_order?(Array(lval), Array(rval))
      return result if [true, false].include?(result)
    end
  end
  nil
end

def perform(input)
  pairs = input.split(/^\n/).map { |pair_buffer| pair_buffer.split(/\n/).map { |packet_buffer| eval(packet_buffer) } }
  pairs.each_with_index.map { |pair, index| proper_order?(*pair) ? index + 1 : 0 }.sum
end

should_return(true).for { proper_order?([1, 1, 3, 1, 1], [1, 1, 5, 1, 1]) }
should_return(true).for { proper_order?([[1], [2, 3, 4]], [[1], 4]) }
should_return(false).for { proper_order?([9], [[8, 7, 6]]) }
should_return(true).for { proper_order?([[4, 4], 4, 4], [[4, 4], 4, 4, 4]) }
should_return(false).for { proper_order?([7, 7, 7, 7], [7, 7, 7]) }
should_return(true).for { proper_order?([], [3]) }
should_return(false).for { proper_order?([[[]]], [[]]) }
should_return(false).for { proper_order?([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]) }

should_return(13).for do
  perform(<<~INPUT)
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
  INPUT
end

puts perform(File.read('input.txt'))
