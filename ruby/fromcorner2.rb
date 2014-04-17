#!/usr/bin/env ruby
require './lib/setup'

$proc = RightAndBackSide.new RainbowWheel.new(RightAndBackSide.size)

main_loop

