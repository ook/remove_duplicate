#!/usr/bin/ruby
## Take in entry a list of path to analyse
## It will scan every files underthem and
## try to detect similar files.
## family -> file_hash -> pathnames

class RemoveDuplicate
  @@config = {
    :dry_run => true,
    :recursive => false,
    :verbose => false
  }

  def initialize(path_as_strings)
  end

  def run
    puts @staged_files.map(&:to_s).join
  end

end
