#!/usr/bin/env ruby
require './lib/setup'

SEGMENT_LENGTH=50
STRAND=[
  [255,255,255],
  [0,0,255],
  [255,255,0],
  [0,255,0]
]

DEADLOOPMIDDLE=429

corner = CORNERS[1]
class RightAndBackSide
  def initialize app
    @app = app
  end

  def call
    p = @app.call
    p = p+p.each_slice(3).to_a.reverse!.flatten!#+[0]*3*(NUM_PIXELS-CORNERS[1]*2)

    deadsegment_length = NUM_SUBPIXELS-CORNERS[1]*3*2
    deadsegment_start = DEADLOOPMIDDLE*3 - deadsegment_length/2
    p.insert(deadsegment_start, *[0]*deadsegment_length)

    p
  end
  def self.length
    CORNERS[1]
  end
end

$proc = RightAndBackSide.new RainbowWheel.new(RightAndBackSide.length)

main_loop

=begin
clear!
loop do
  (0...NUM_PIXELS).each do |i|
    (0...NUM_PIXELS).each do |x|
      c = STRAND[(i+x)/SEGMENT_LENGTH%STRAND.length]
      setpixel x, c
    end
    show
  end
end
=end
