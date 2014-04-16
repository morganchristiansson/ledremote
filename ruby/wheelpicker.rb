#!/usr/bin/env ruby
require './lib/setup'

clear!
setpixel 0, [255]*3
$proc = lambda { $p }
$proc = $rotation = Rotating.new $proc

#171

Thread.new do
  main_loop
end

loop do
  case c = read_char
  when "\r"
    $stderr.puts $rotation.value
  when "\e"
    require 'pry' ; binding.pry

  when "\e[A"
    $rotation.speed += 1 if $rotation
  when "\e[B"
    $rotation.speed -= 1 if $rotation
  when "\e[C"
    $rotation.value += 1 if $rotation
  when "\e[D"
    $rotation.value -= 1 if $rotation
  when "\u0003"
    $stderr.puts "^C"
    exit

  when /^.$/
    puts "SINGLE CHAR HIT: #{c.inspect}"
  else
    puts "SOMETHING ELSE: #{c.inspect}"
  end
end

