# frozen_string_literal: true

require 'byebug'
require_relative '../assertion'

# Infos of a file
class FileInfos
  attr_reader :name, :size

  def initialize(line)
    @size = line[/[0-9]*/].to_i
    @name = line.split.last
  end
end

# Infos of a directory
class DirectoryInfos
  attr_reader :name, :parent, :entries

  def initialize(line, parent)
    @name = line.split.last
    @parent = parent
    @entries = {}
  end

  def size
    @size ||= entries.values.map(&:size).sum
  end
end

# Root
class RootDirectoryInfos
  def self.root
    @root ||= DirectoryInfos.new('/', self)
  end

  def self.entries
    @entries ||= { '/' => root }
  end

  def self.size
    root.size
  end
end

def perform(input)
  directories = []
  current = RootDirectoryInfos
  input.split(/\n/).map(&:chomp).each do |line|
    case line
    when '$ cd ..'
      current = current.parent
    when /^\$ cd /
      current = current.entries[line.split.last]
    when /^dir /
      directories << directory_infos = DirectoryInfos.new(line, current)
      current.entries[directory_infos.name] = directory_infos
    when /^[1-9][0-9]* /
      file_infos = FileInfos.new(line)
      current.entries[file_infos.name] = file_infos
    else # should be a ls, can ignore it for now
      raise "Parsing error: #{line}" unless line == '$ ls'
    end
  end
  directories.map(&:size).select { |size| size < 100_000 }.sum
end

should_return(95_437).for do
  perform(<<~INPUT)
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
  INPUT
end

puts perform(File.read('input.txt'))
