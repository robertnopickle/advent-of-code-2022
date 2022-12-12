instructions = File.read("day10/sample.txt").split("\n")

class CRT
  LIT_PIXEL = "#"
  DARK_PIXEL = "."

  def initialize
    @screen = Array.new(6) { Array.new(40, DARK_PIXEL) } # 40w X 6h
  end

  def draw(x, y)
    @screen[y][x] = LIT_PIXEL
  end

  def print_screen
    @screen.each do |row|
      puts row.join
    end
  end
end

class Device
  def initialize
    @register = 1
    @cycle = 1
    @stack = []
    @crt = CRT.new
  end
  attr_accessor :cycle, :register, :stack, :crt

  def run(instruction)
    stack << 0
    stack << instruction.split(" ").last.to_i if instruction.start_with?("addx")
    cycle_cpu
  end

  private

  def cycle_cpu
    stack.each do |val|
      draw_pixel if draw_pixel?
      add(val)
      @cycle += 1
    end
    @stack = []
  end

  def add(val)
    @register += val
  end

  def draw_pixel?
    draw_range = (-1..1)
    draw_range.include?(position_relative_to_cycle - register)
  end

  def draw_pixel
    x = position_relative_to_cycle
    y = current_line
    @crt.draw(x, y)
  end

  def position_relative_to_cycle
    # returns a zero-based index of the horizontal position
    # for the current cycle
    r = cycle % 40 - 1
    if r == -1
      39
    else
      r
    end
  end

  def current_line
    # returns a zero-based index of the current verical line
    l = cycle / 40
    if position_relative_to_cycle == 39
      l - 1
    else
      l
    end
  end
end

# begin script
device = Device.new
instructions.each do |instruction|
  device.run(instruction)
end

device.crt.print_screen
