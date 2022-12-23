# frozen_string_literal: true

require_relative '../assertion'

def compare(left, right)
  # Hack for Array#zip not padding left missing values
  left += [nil] * (right.size - left.size) if right.size > left.size

  left.zip(right).each do |lval, rval|
    return -1 if lval.nil?
    return 1 if rval.nil?

    if rval.is_a?(Integer) && lval.is_a?(Integer)
      return (lval <=> rval) unless rval == lval
    else
      result = compare(Array(lval), Array(rval))
      return result unless result.zero?
    end
  end
  0
end

def perform(input)
  packets = input.split(/\n/).map { |line| eval(line) }.compact + [[[2]], [[6]]]
  packets.sort! { |a, b| compare(a, b) }
  (packets.index([[2]]) + 1) * (packets.index([[6]]) + 1)
end

should_return(140).for do
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
