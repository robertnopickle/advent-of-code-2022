terminal_output = File.read("input/d07.txt").split("\n")

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

  def directories_at_least_as_large_as(size:, directory: @root)
    # returns all directories with a total size less than the given size
    directory.subdirs.select { |dir| dir.total_size >= size } +
      directory.subdirs.flat_map { |dir| directories_at_least_as_large_as(size: size, directory: dir) }
  end
end

# parse the terminal output into a file structure
fs = FileStructure.new
terminal_output.each { |line| fs.process_line(line) }

# find the smallest directory that needs to be deleted to have 30MB of free space on the disk
total_disk_space = 70_000_000
required_free_space = 30_000_000
maximum_used_space = total_disk_space - required_free_space
size_to_free_up = fs.root.total_size - maximum_used_space
small_dirs = fs.directories_at_least_as_large_as(size: size_to_free_up)
puts small_dirs.map(&:total_size).sort.first
