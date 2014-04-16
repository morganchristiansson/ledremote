#!/usr/bin/env ruby
require 'bundler/setup'
require './setup'

def clear!
  $p = CyclicArray.new(NUM_SUBPIXELS, 1)
end

def white
  $p = CyclicArray.new(NUM_SUBPIXELS, 255)
end

def setpixel i, values = [255,255,255]
  $p[i*3, values.length] = values
end

def trail
  setpixel 0, [255]*3 +
              [255]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3 +
              [100]*3
end

######## main

corners = [ 61, # middle left
           149, # back left
           238, # back right
           328, # middle right
           419, # front right
           499] # front left

def escape_0 pixels
  pixels.map! { |p| p == 0 ? 1 : p }
end

clear!

#setpixel 0, [255]*3
#trail
#corners.each { |c| setpixel c }

#$proc = lambda { $p }
$proc = RainbowWheel.new

#$proc = RainbowWheel.new(182)
#$proc = $zap = Zap.new 182

#$proc = $blur = Blur.new $proc

#$proc = $rotation = Rotating.new $proc

def right_side
  # 238 + 182 + 80 = 500
  [1]*3*238+$proc.call+[1]*3*80
end

# wait for boot message
$stderr.puts @serial.gets

Thread.abort_on_exception=true

Thread.new do
#begin
  loop do
    show $proc.call
  end
end

loop do
  case c = read_char
  when "\r"
    $stderr.puts -$rotation.value+1500
  when "\e"
    require 'pry' ; binding.pry

  when "\e[A"
    $zap.speed += 1
  when "\e[B"
    $zap.speed -= 1
  when "\e[C"
    $zap.length += 1
  when "\e[D"
    $zap.length -= 1

  when "\u0003"
    $stderr.puts "^C"
    exit

  when /^.$/
    puts "SINGLE CHAR HIT: #{c.inspect}"
  else
    puts "SOMETHING ELSE: #{c.inspect}"
  end
end

