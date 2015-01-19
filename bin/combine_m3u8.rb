#!/usr/bin/env ruby
require 'open-uri'
require 'pry'

url = "http://drod01s-vh.akamaihd.net/i/all/clear/streaming/be/54a03a176187a2053cfc4ebe/P6-BEAT-med-Mikael-Simpson-og-_b3ab8d96bb5b4f8380bf0dbe4bee3880_,192,61,.mp4.csmil/master.m3u8"

def get uri
  open(uri).read
end

repo = get(url)
lines = repo.split("\n")
qualities = {}
lines.each_with_index do |line, i|
  if match = line.match(/BANDWIDTH=(\d+)/)
    qualities[match[1]] = lines[i + 1]
  end
end

list = qualities[qualities.keys.sort.first]
files = get(list).split("\n").grep /^http.*/

filename = 'tmp.ts'
`rm #{filename}`

files.each do |uri|
  puts uri
  File.open(filename, 'a') { |f| f << open(uri).read }
end
