terminal_output = File.read("day07/sample.txt").split("\n")

# File is a class with a name and a file size
class File
  attr_reader :name, :size
  def initialize(name, size)
    @name = name
    @size = size.to_i
  end
end

# Directory is a class that holds files and subdirectories, and a reference to its parent directory
class Directory
  attr_reader :name, :files, :subdirs, :parent
  def initialize(name:, parent: nil)
    @name = name
    @files = []
    @subdirs = []
    @parent = parent
  end

  def add_file(file)
    @files << file
  end

  def add_subdir(dir)
    @subdirs << dir
  end

  def total_size
    @files.map(&:size).sum + @subdirs.map(&:total_size).sum
  end
end

class FileStructure
  attr_reader :root
  def initialize
    @root = Directory.new(name: "/")
    @current_working_dir = @root
  end

  def process_line(line)
    # don't care about these commands due to the starting point of the file structure.
    return if line == "$ cd /" || line == "$ ls"

    if line.start_with?("$ cd") # change directory
      cd(line.split(" ").last)
    elsif line.start_with?("dir") # add a subdirectory
      mkdir(line.split(" ").last)
    else # add a file
      (size, name) = line.split(" ")
      file = File.new(name, size)
      @current_working_dir.add_file(file)
    end
  end

  def cd(dir_name)
    @current_working_dir =
      if dir_name == ".."
        @current_working_dir.parent
      else
        @current_working_dir.subdirs.find { |dir| dir.name == dir_name }
      end
  end

  def mkdir(dir_name)
    sub_dir = Directory.new(name: dir_name, parent: @current_working_dir)
    @current_working_dir.add_subdir(sub_dir)
  end

  def collect_small_directories(max_size:, directory: @root)
    # returns all directories with a total size less than the given size
    directory.subdirs.select { |dir| dir.total_size < max_size } +
      directory.subdirs.flat_map { |dir| collect_small_directories(max_size: max_size, directory: dir) }
  end
end

# parse the terminal output into a file structure
fs = FileStructure.new
terminal_output.each { |line| fs.process_line(line) }

# collect the all directories with a total size less than 100,000
small_dirs = fs.collect_small_directories(max_size: 100_000)
puts small_dirs.map(&:total_size).sum # output the total sizes of all the small directories
