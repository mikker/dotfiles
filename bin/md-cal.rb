#!/usr/bin/env ruby

require 'time'

month = (ARGV.shift || Date.today.month).to_i
year = (ARGV.shift || Date.today.year).to_i

COMMON_YEAR_DAYS_IN_MONTH =
  %w[nil 31 28 31 30 31 30 31 31 30 31 30 31].map(&:to_i)

def days_in_month(month, year)
  if month == 2 && ::Date.gregorian_leap?(year)
    29
  else
    COMMON_YEAR_DAYS_IN_MONTH[month]
  end
end

first = Date.new(year, month, 1)
days = (1..days_in_month(month, year)).to_a
(first.cwday - 1).times { days.unshift(nil) }
(days.length % 7 + 1).times { days.push(nil) }

table = days.reduce([[]]) do |cal, day|
  if cal.last.length < 7
    cal.last.push(day)
  else
    cal.push([day])
  end

  cal
end

table.unshift(Array.new(7).map { ":-:" })
table.unshift(%w[Mon Tue Wed Thu Fri Sat Sun])

puts(table.map do |line|
  "| " + line.map { |c| c.to_s.ljust(3) }.join(" | ") + " | "
end.join("\n"))
