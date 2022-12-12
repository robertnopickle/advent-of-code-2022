instructions = File.read(ENV.fetch("input")).split("\n")

class CPU
  def initialize
    @register = 1
    @cycle = 1
    @stack = []
    @signal_strength_log = []
  end
  attr_accessor :cycle, :register, :stack, :signal_strength_log

  def run(instruction)
    stack << 0
    stack << instruction.split(" ").last.to_i if instruction.start_with?("addx")
    cycle_cpu
  end

  private

  def cycle_cpu
    stack.each do |val|
      signal_strength_log << register * cycle if measure_signal_strength?
      add(val)
      @cycle += 1
    end
    @stack = []
  end

  def add(val)
    @register += val
  end

  def measure_signal_strength?
    # measure signal strength every 40 cycles, starting at cycle 20.
    # (20, 60, 100, 140, ...)
    (cycle + 20) % 40 == 0
  end
end

# begin script
cpu = CPU.new

instructions.each do |instruction|
  cpu.run(instruction)
end

puts cpu.signal_strength_log.sum
