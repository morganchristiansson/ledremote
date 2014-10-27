#!/usr/bin/env ruby
require './lib/setup'
require 'socket'

require 'pry'

wait_for_boot

server = TCPServer.new 2000
$proc = lambda { [0,0,0]*NUM_PIXELS }
main_thread = Thread.new { main_loop }

server_thread = Thread.new do
  loop do
    begin
      STDERR.puts 'waiting for connection'
      client = server.accept
      Thread.new do
        begin
          while line = client.gets
            cmd, line = line.split(' ', 2)
            $stderr.puts "Received command: #{cmd}: #{line}"

            case cmd
            when 'RGB'
              rgb = *line.split(' ').map(&:to_i)
              $stderr.puts "rgb = #{rgb.inspect}"
              #$led.set *rgb
              $proc = lambda { rgb*NUM_PIXELS }
              client.puts "ok"
            when 'EFFECT'
              $stderr.puts "EFFECT"
              $proc = RainbowWheel.new
              client.puts "ok"
            else
              $stderr.puts "Unknown command: #{cmd}: #{line}"
            end
          end
        rescue
          $stderr.puts $!
          $stderr.puts $!.backtrace.join "\n"
          client.puts $!
          client.puts $!.backtrace.join "\n"
        end
      end
    rescue
      $stderr.puts $!
    end
  end
end

binding.pry
