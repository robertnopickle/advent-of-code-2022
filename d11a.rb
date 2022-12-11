monkeys_input = File.read("input/d11.txt")
$monkeys = []

class Monkey
  def initialize(starting_items: [], operation_details:, test_details:)
    @items = starting_items
    @operation_details = operation_details
    @test_details = test_details
    @inpection_count = 0
  end
  attr_accessor :items, :operation_details, :test_details, :inpection_count

  def inspect_items
    items.each { |item| inspect_item(item)}
    @items = []
  end

  private

  def inspect_item(item)
    new_item_value = update_items_worry_level(item)
    destination_monkey = destination_monkey(new_item_value)
    $monkeys[destination_monkey].items << new_item_value
    @inpection_count += 1
  end

  def update_items_worry_level(level)
    operands = operation_details[:operands].map do |operand|
      operand.is_a?(Integer) ? operand : level
    end

    # <first operand> <operator> <second operand> / 3
    operands[0].send(operation_details[:operator], operands[1]) / 3
  end

  def destination_monkey(item)
    test_item?(item) ? test_details[:true_monkey] : test_details[:false_monkey]
  end

  def test_item?(item)
    item % test_details[:divisible_by] == 0
  end
end

def parse_starting_items(starting_items_string)
  starting_items_string.gsub("  Starting items: ", "").split(", ").map(&:to_i)
end

def parse_operation_details(operation_string)
  operation_input = operation_string.gsub("  Operation: new = ", "").split(" ")
  operator = operation_input[1].to_sym
  operands = []
  [operation_input.first, operation_input.last].each do |operand|
    if operand.match?(/\d+/) # if operand is a number
      operands << operand.to_i
    else
      operands << operand
    end
  end

  { operator: operator, operands: operands }
end

def parse_test_details(test_input)
  test_details = { divisible_by: test_input[0].gsub("  Test: divisible by ", "").to_i }
  test_details.merge!({ true_monkey: test_input[1].gsub("    If true: throw to monkey ", "").to_i })
  test_details.merge!({ false_monkey: test_input[2].gsub("    If false: throw to monkey ", "").to_i })
end

# BEGIN script...
# parse the input into an array of Monkey objects
monkeys_input.split("\n").each_slice(7) do |input|
  $monkeys << Monkey.new(
    starting_items: parse_starting_items(input[1]),
    operation_details: parse_operation_details(input[2]),
    test_details: parse_test_details(input[3..5])
  )
end

# monkeys take turns for 20 rounds...
20.times do
  $monkeys.each do |monkey|
    monkey.inspect_items
  end
end

# print the product of the two higest inspection counts
puts $monkeys.map(&:inpection_count).sort.reverse[0..1].reduce(:*)
