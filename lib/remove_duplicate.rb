#!/usr/bin/ruby
## Take in entry a list of path to analyse
## It will scan every files underthem and
## try to detect similar files.
## family -> file_hash -> [pathnames]
require 'pathname'
require 'digest/md5'

class RemoveDuplicate

  def initialize(path_as_strings)
    @config = {
      :dry_run   => true,
      :recursive => false,
      :verbose   => false
    }
    stage_files(path_as_strings)
    @scanned = {}
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

  # pathname: a readable pathname
  def hash(pathname)
    ext = pathname.extname
    ext = ('' == ext || nil == ext) ? :none : ext.to_sym
    digest = Digest::MD5.hexdigest(File.read(pathname.to_s))
    @scanned[ext] ||= {}
    @scanned[ext][digest] ||= []
    @scanned[ext][digest] << pathname
  end

  def run
    puts "#{@staged_files.length} staged files"
    puts @staged_files.map(&:to_s).join
    @staged_files.each { |pathname| hash(pathname) }
    puts dump
  end

  def dump
    output = ''
    @scanned.keys.each do |ext|
      @scanned[ext].keys.each do |digest|
        output << "#{ext.to_s}->#{digest}->#{@scanned[ext][digest].join(',')}\n"
      end
    end
    output
  end

end
