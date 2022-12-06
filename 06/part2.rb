# frozen_string_literal: true

require_relative '../assertion'

def perform(input)
  buffer = input.chomp
  (13...input.size).each do |index|
    packs_of_four = buffer[(index - 13)..index]
    return index + 1 if packs_of_four.chars.uniq.size == 14
  end
end

should_return(19).for { perform('mjqjpqmgbljsphdztnvjfqwrcgsmlb') }
# bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
should_return(23).for { perform('bvwbjplbgvbhsrlpgdmjqwftvncz') }
# nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
should_return(23).for { perform('nppdvjthqldpwncqszvftbrmjlhg') }
# nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
should_return(29).for { perform('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg') }
# zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11
should_return(26).for { perform('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw') }

puts perform(File.read('input.txt'))
