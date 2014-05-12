#!/usr/bin/env ruby
require './lib/setup'
require 'socket'

wait_for_boot

server = TCPServer.new 2000
loop do
  begin
    STDERR.puts 'waiting for connection'
    client = server.accept
    while line = client.gets
      begin
        rgb = *line.split(' ').map(&:to_i)
        $stderr.puts "rgb = #{rgb.inspect}"
        #$led.set *rgb
        show rgb*NUM_PIXELS
        client.puts "ok"
      rescue
        client.puts $!
        client.puts $!.backtrace.join "\n"
      end
    end
  rescue
    $stderr.puts $!
  end
end

