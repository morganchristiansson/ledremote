#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+"/lib"
require 'setup'

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

corners = [ 88, # back right
           #379, # middle right
           269, # front right
           357, # front left
           # 61, # middle left
           599] # back left


def escape_0 pixels
  pixels.map! { |p| p == 0 ? 1 : p }
end

clear!

setpixel 0, [255]*3
#trail
#corners.each { |c| setpixel c }

=begin
$proc = lambda { $p }
$proc = $rotation = Rotating.new $proc
=end

#$proc = RainbowWheel.new(182)
$proc = $zap = Zap.new(182)
$proc = RightSide.new($proc)

#$proc = $blur = Blur.new $proc


#$proc = RightSide.new(Zap.new(182))

$proc ||= RainbowWheel.new

# wait for boot message
$stderr.puts @serial.gets

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

