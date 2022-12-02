# frozen_string_literal: true

max = []
current = 0
File.readlines('input.txt').each do |line|
  line = line.chomp
  if line.empty?
    max = (max + [current]).sort.reverse[0..2]
    current = 0
  else
    current += line.to_i
  end
end

puts max.sum
