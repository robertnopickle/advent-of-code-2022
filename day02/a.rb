rounds = File.read("day2/sample.txt").split("\n")

# Hand is an identity class for hands in rounds of rock, paper, scissors
class Hand
  KEYS = { :rock => 'AX', :paper => 'BY', :scissors => 'CZ' }

  def initialize(t)
    @t = t
  end
  attr_reader :t

  KEYS.each do |key, value|
    define_method(key) do
      value.include?(t)
    end
  end

  def score
    if rock
      1
    elsif paper
      2
    else #scissors
      3
    end
  end
end

# begin running through the rounds...
score = 0
rounds.each do |round|
  theirs = Hand.new(round[0])
  mine = Hand.new(round[2])

  if ( # win
    (theirs.rock && mine.paper) ||
    (theirs.paper && mine.scissors) ||
    (theirs.scissors && mine.rock))
    score += 6
  elsif (theirs.score == mine.score) # tie
    score += 3
  end # else lose

  score += mine.score
end

puts score
