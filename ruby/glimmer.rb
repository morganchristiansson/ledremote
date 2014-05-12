#!/usr/bin/env ruby
require './lib/setup'
wait_for_boot

C=[80,255,0]

clear!

@speed = 0
@multiplier = 0.9
(0...10000).cycle.each do |offset|
  (0...NUM_PIXELS).each do |i|
    @multiplier -= 0.000_000_1
    setpixel(i, C.map { |c| (c * Math.sin(i*@multiplier-offset*@speed)).to_i.abs })
  end
  show $p
end

