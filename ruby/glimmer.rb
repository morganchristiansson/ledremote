#!/usr/bin/env ruby
require './lib/setup'
wait_for_boot

C=[80,255,0]
PINK = [0, 255, 59]
GOLD = [255, 80, 0]

class Glimmer < Effect
  def initialize app
    @app = app
    @multiplier = 0.2
  end

  def call
    pixels = @app.call

    @multiplier -= 0.0001

    pixels = pixels.each_slice(3).each_with_index.map do |rgb, i|
      rgb.map! do |c|
        (c * Math.sin(i*@multiplier)).to_i.abs
      end
    end.flatten

    pixels
  end
end

$proc = Glimmer.new Proc.new { GOLD * NUM_PIXELS }
#$proc = Glimmer.new RainbowWheel.new
#$proc = RainbowWheel.new

main_loop

