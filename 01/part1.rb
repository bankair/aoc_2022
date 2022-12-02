# frozen_string_literal: true

max = 0
current = 0
File.readlines('input.txt').each do |line|
  line = line.chomp
  if line.empty?
    max = [max, current].max
    current = 0
  else
    current += line.to_i
  end
end

puts max
