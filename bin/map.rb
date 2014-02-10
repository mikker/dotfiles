#!/usr/bin/env ruby
begin
  require 'exifr'
rescue LoadError
  require 'rubygems'
  require 'exifr'
end

usage = <<-USAGE
usage: map.rb IMAGE_PATH
USAGE

path = ARGV.shift

if path.nil?
  puts usage
  exit(0)
end

exif = EXIFR::JPEG.new(path)
if coords = exif.gps
  system "open 'http://maps.apple.com/?q=#{coords.latitude},#{coords.longitude}'"
else
  puts "No GPS data for #{path}"
end
