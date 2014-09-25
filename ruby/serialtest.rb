#!/usr/bin/env ruby
require 'rubygems'  
require 'serialport'
require 'timeout'

@serial = SerialPort.new("/dev/ttyACM0", "baud" => 1000000)
sleep 1

$pixels = (["\n".ord, 0] + [255]*1500)
$str = $pixels.pack("C"*$pixels.length)

def verify_response r
  $stderr.write r and return
  if r
    if r.chomp == $str
      $stderr.write "_"
    else
      $stderr.write "E"
    end
  end
end

writeahead = 1
loop do
  begin
    $stderr.puts "."
    writeahead.times { @serial.write $str }
    sleep 1
    #timeout(1) do
      #writeahead.times { verify_response @serial.gets }
    #end rescue nil
    $stderr.write @serial.read_nonblock(10000) rescue nil
  #rescue
  #  $stderr.puts "!"
  end
end

