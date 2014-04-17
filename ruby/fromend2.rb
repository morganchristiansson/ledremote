#!/usr/bin/env ruby
require './lib/setup'

class Pixel
  attr_accessor :rgb
  def initialize r=0,g=0,b=0
    @rgb = [r,g,b]
  end
end

start_length = CORNERS[0]
right_side_length = CORNERS[1]-CORNERS[0]
end_length = CORNERS[2]-CORNERS[1]
left_side_length = CORNERS[3]-CORNERS[2]

start_range = 0...1
right_side_range = start_range.end...(start_range.end+right_side_length)
end_range = right_side_range.end...(right_side_range.end+end_length)
#left_side_range = end_range.end...(end_range.end+right_side_length)

$proc = RainbowWheel.new 1+right_side_length+1
loop do
  p = p1 = $proc.call.each_slice(3).map {|rgb|Pixel.new *rgb}

  p2 = p[start_range] * start_length +
       p[right_side_range] +
       p[end_range] * end_length +
       p[right_side_range].reverse

  #p.map(&:rgb).flatten
  p3 = p2.map(&:rgb).flatten
  insert_deadsegment(p3)
  show p3
end
binding.pry

