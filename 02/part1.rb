# frozen_string_literal: true

ROCK = :rock
PAPER = :paper
CISSORS = :cissors

MOVES = {
  'A' => ROCK,
  'B' => PAPER,
  'C' => CISSORS,
  'X' => ROCK,
  'Y' => PAPER,
  'Z' => CISSORS
}.freeze

SCORES = { ROCK => 1, PAPER => 2, CISSORS => 3 }.freeze
NEMESISES = { ROCK => PAPER, PAPER => CISSORS, CISSORS => ROCK }.freeze

def outcome(opponent, yours)
  return 3 if opponent == yours

  NEMESISES[opponent] == yours ? 6 : 0
end

result = 0
File.readlines('input.txt').each do |line|
  opponent, yours = line.chomp.split.map { |str| MOVES[str] }
  result += SCORES[yours] + outcome(opponent, yours)
end

puts result
