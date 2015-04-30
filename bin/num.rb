#!/usr/bin/env ruby

# KRAK on the command line

begin
  require 'nokogiri'
rescue LoadError => e
  puts "$ gem install nokogiri"
  exit 1
end

require 'open-uri'
require 'json'

class String
  def blank?
    nil? || self === ""
  end
end

num = ARGV.to_a.join(' ')
if num.blank?
  puts "usage: num.rb NUMBER"
  exit 1
end

def format_number num
  num.tr(' ', '').gsub(/^\+45/, '')
end

def result_as_json lines
  keys = [:name, :phone, :address, :postal_code, :city]
  (0...lines.length).inject({}) do |hsh, i|
    hsh.merge keys[i] => lines[i]
  end.to_json
end

num = format_number num
puts "Looking up #{num}"

begin
  handler = Nokogiri::XML(open("http://www.krak.dk/person/resultat/#{num}"))
rescue OpenURI::HTTPError => e
  puts "No match"
  exit 1
end

elements = handler.css('.hit-name-ellipsis, .type-phone_normal_mobile, .hit-address-line')
values = elements.text.split(/\n+/).reject(&:blank?).compact
puts result_as_json values

