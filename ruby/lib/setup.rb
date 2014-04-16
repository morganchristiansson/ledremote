$: << File.dirname(__FILE__)
require 'rubygems'
require 'bundler/setup'

require 'active_support/core_ext/enumerable'
require 'serialport'
require 'timeout'
require 'benchmark'

require 'read_char'
require 'effects'

@serial = SerialPort.new("/dev/ttyACM0", "baud" => 1000000)

NUM_PIXELS=600
NUM_SUBPIXELS=NUM_PIXELS*3
PAYLOAD_SIZE=1801

corners = [ 88, # back right
           #379, # middle right
           269, # front right
           357, # front left
           # 61, # middle left
           599] # back left

def main_loop
  loop do
    show $proc.call
  end
end

def wait_until_ready
  r = @serial.readchar
  $stderr.write r if $verbose
  print_from_serial

  true
rescue EOFError
  retry
end

def loop_time
  t=Time.now
  $stderr.puts t - $t if $t
  $t = t
end

def show pixels=$p
  if pixels.length != NUM_SUBPIXELS
    $stderr.puts "Received incorrect number of pixels #{pixels.length}, expected #{NUM_SUBPIXELS} pixels"
    return
  end

  chunk = ["\n".ord,0]
  @serial.write chunk.pack('C'*chunk.size)
  @serial.flush
  $stderr.write "." if $verbose

  return unless wait_until_ready
  #pixels = pixels.map { |i| i == "\n".ord ? "\n\n".bytes : i }.flatten
  pixels = pixels.map { |i| i == 10 ? 11: i }
  @serial.write pixels.pack('C'*pixels.size)
  #pixels.each_slice(16) do |chunk|
  #  @serial.write chunk.pack('C'*chunk.size)
  #end
  @serial.flush
  print_from_serial
  nil
end

def print_from_serial
  $stderr.write @serial.read_nonblock(10000) rescue nil
end

def clear!
  $p = CyclicArray.new(NUM_SUBPIXELS, 1)
end

def white
  $p = CyclicArray.new(NUM_SUBPIXELS, 255)
end

def setpixel i, values = [255,255,255]
  $p[i*3, values.length] = values
end

class CyclicArray < Array
  def fix_index i
    i += length while i < 0
    i -= length while i >= length
    i
  end

  def [] *args
    if args.length == 1 && args[0].is_a?(Fixnum)
      args[0] = fix_index(args[0])
    end
    super *args
  end
end

