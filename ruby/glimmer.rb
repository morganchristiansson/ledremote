#!/usr/bin/env ruby
require './lib/setup'
wait_for_boot

C=[80,255,0]

clear!

(0...10000).cycle.each do |offset|
  (0...NUM_PIXELS).each do |i|
    setpixel(i, C.map { |c| (c * Math.sin(i/1.1+offset/20.0)).to_i.abs })
  end
  show $p
end

