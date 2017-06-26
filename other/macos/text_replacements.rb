#!/usr/bin/env ruby

replacements = {
  xkk: '😘',
  xyy: '👍🏻',
  xdd: '😔',
  xss: '☺️',
  xgg: '😂'
}

replacements.each do |key, val|
  system "defaults write -g NSUserDictionaryReplacementItems -array-add '{on=1;replace=#{key};with=\"#{val}\";}'"
end

system "defaults read -g NSUserDictionaryReplacementItems"
