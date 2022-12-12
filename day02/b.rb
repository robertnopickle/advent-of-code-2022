rounds = File.read("day2/sample.txt").split("\n")

# Hand is a class to decode hands in rounds of rock, paper, scissors
class Hand
  KEYS = {
    :rock =>      { :code => 'A', :wins_against => 'C', :loses_against => 'B', :score => 1, :name => 'rock' }, 
    :paper =>     { :code => 'B', :wins_against => 'A', :loses_against => 'C', :score => 2, :name => 'paper' },
    :scissors =>  { :code => 'C', :wins_against => 'B', :loses_against => 'A', :score => 3, :name => 'scissors' },
  }

  def initialize(t)
    @key = KEYS.find { |k, v| v[:code] == t }[1][:name].to_sym
  end
  attr_reader :key
end

# Result is a class to decode the result of a round
class Result
  KEYS = { :lose => 'X', :tie => 'Y', :win => 'Z' }

  def initialize(r)
    @r = r
  end

  KEYS.each { |key, value| define_method(key) { value.include?(@r) } }
end

# begin running through the rounds...
score = 0
rounds.each do |round|
  theirs = Hand.new(round[0])
  result = Result.new(round[2])
  mine = nil

  if (result.win)
    mine = Hand.new(Hand::KEYS[theirs.key][:loses_against])
    score += 6
  elsif (result.tie) # tie
    mine = Hand.new(Hand::KEYS[theirs.key][:code])
    score += 3
  else # lose
    mine = Hand.new(Hand::KEYS[theirs.key][:wins_against])
  end

  score += Hand::KEYS[mine.key][:score]
end

puts score
