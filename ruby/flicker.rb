#!/usr/bin/env ruby
require './lib/setup'
wait_for_boot

def hsv_to_rgb(h, s, v)
  h_i = (h*6).to_i
  f = h*6 - h_i
  p = v * (1 - s)
  q = v * (1 - f*s)
  t = v * (1 - (1 - f) * s)
  r, g, b = v, t, p if h_i==0
  r, g, b = q, v, p if h_i==1
  r, g, b = p, v, t if h_i==2
  r, g, b = p, q, v if h_i==3
  r, g, b = t, p, v if h_i==4
  r, g, b = v, p, q if h_i==5
  [(r*256).to_i, (g*256).to_i, (b*256).to_i]
end

clear!

thishue = 160
thissat = 50

loop do
  random_bright = rand(0..255)
  random_delay = rand(0.010..0.100)
  random_bool = rand(0..random_bright)
  #$stderr.write random_bool < 10 ? 't' : 'f'
  if random_bool < 10
    begin
      c = hsv_to_rgb(thishue/255.0, thissat/255.0, random_bright/255.0)
      (0...NUM_PIXELS).each do |i|
        setpixel i, c
      end
      #binding.pry
      show
      sleep(random_delay)
    #rescue
    #  $stderr.puts '#'
    end
  end
end

