#!/usr/bin/env ruby
require './lib/setup'



=begin
clear!
setpixel 0, [255]*3
#corners.each { |c| setpixel c }
$proc = lambda { $p }
$proc = $rotation = Rotating.new $proc
=end

#$proc = RainbowWheel.new(182)
$proc = $zap = Zap.new(182)
$proc = RightSide.new($proc)

#$proc = RightSide.new(Zap.new(182))

$proc ||= RainbowWheel.new

wait_for_boot

Thread.abort_on_exception=true

Thread.new do
#begin
  main_loop
end

loop do
  case c = read_char
  when "\r"
    $stderr.puts -$rotation.value+1500
  when "\e"
    require 'pry' ; binding.pry

  when "\e[A"
    $zap.speed += 1 if $zap
    $rotation.speed += 1 if $rotation
  when "\e[B"
    $zap.speed -= 1 if $zap
    $rotation.speed -= 1 if $rotation
  when "\e[C"
    $zap.length += 1 if $zap
    $rotation.value += 1 if $rotation
  when "\e[D"
    $zap.length -= 1 if $zap
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

