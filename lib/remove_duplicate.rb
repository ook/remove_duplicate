#!/usr/bin/ruby
## Take in entry a list of path to analyse
## It will scan every files underthem and
## try to detect similar files.
## family -> file_hash -> pathnames
require 'pathname'

class RemoveDuplicate

  def initialize(path_as_strings)
    @config = {
      :dry_run   => true,
      :recursive => false,
      :verbose   => false
    }
    stage_files(path_as_strings)
  end

  def stage_files(path_as_strings)
    @staged_files ||= []
    path_as_strings.each do |path|
      pathname = Pathname.new(path)
      if pathname.directory?
        staged_files(pathname.entries) if @config[:recursive] 
      else 
        @staged_files << pathname if pathname.readable?
      end
    end
    @staged_files
  end

  def run
    puts "#{@staged_files.length} staged files"
    puts @staged_files.map(&:to_s).join
  end

end
