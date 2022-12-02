# frozen_string_literal: true

ROCK = :rock
PAPER = :paper
CISSORS = :cissors

SCORES = { ROCK => 1, PAPER => 2, CISSORS => 3 }.freeze
WINNERS = { ROCK => PAPER, PAPER => CISSORS, CISSORS => ROCK }.freeze
LOSERS = Hash[WINNERS.to_a.collect(&:reverse)]

result = 0
File.readlines('input.txt').each do |line|
  opponent, target = line.chomp.split
  opponent = { 'A' => ROCK, 'B' => PAPER, 'C' => CISSORS }[opponent]
  result +=
    if target == 'X'
      SCORES[LOSERS[opponent]]
    elsif target == 'Y'
      3 + SCORES[opponent]
    else # target == 'Z'
      6 + SCORES[WINNERS[opponent]]
    end
end

puts result
