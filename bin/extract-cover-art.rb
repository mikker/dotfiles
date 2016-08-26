#!/usr/bin/env ruby
begin
  require 'taglib'
rescue LoadError
  puts '$ [sudo] gem install taglib-ruby'
  raise
end

input = ARGV.shift
raise "Missing filename" if input.nil?

output = "#{File.basename(input)}.jpg"

cover = TagLib::MPEG::File.open(input) do |mp3|
  mp3.id3v2_tag.frame_list('APIC').first.picture
end

File.open(output, 'wb') { |f| f << cover }

puts "Wrote #{output}"
