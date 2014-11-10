#!/usr/bin/env ruby
#require './lib/setup'

require 'pry'

END_ANGLE = 53.13
SIDE_ANGLE = 126.87
# END_ANGLE*2 + SIDE_ANGLE*2 = 360

FR_DEG = END_ANGLE/2
BR_DEG = FR_DEG + SIDE_ANGLE
BL_DEG = BR_DEG + END_ANGLE
FL_DEG = BL_DEG + SIDE_ANGLE

BR_POS = 88
MR_POS = 178
FR_POS = 269
FL_POS = 357
ML_POS = 61
BL_POS = 599

def light_angle deg
  if deg < FR_DEG
  elsif deg < BR_DEG
    ldeg = deg - FR_DEG
    multip = ldeg / SIDE_ANGLE
    
    num_leds = BR_POS - FR_POS
    led_pos = num_leds * multip
    $p = [0]*(1800-3)
    $p.insert FR_POS + led_pos, *[255]*3
    
    
  elsif deg < BL_DEG
  elsif deg < TL_DEG
  end
end

binding.pry

