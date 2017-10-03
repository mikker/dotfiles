#!/usr/bin/env ruby
#
# Gets the original feed url from an iTunes podcast page
#
# usage:
#   itunes-feed.rb URL
#

require 'open-uri'
require 'json'

feed = ARGV.shift

if id = feed[/id(\d+)/, 1]
  url = "https://itunes.apple.com/lookup?id=#{id}&entity=podcast"
  json = JSON.parse(open(url).read)
  print json['results'][0]['feedUrl']
end
