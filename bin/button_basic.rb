#!/usr/bin/env ruby
puts "starting....."
require 'pi_piper'
include PiPiper

t=Time.now
pin=PiPiper::Pin.new(:pin => 23, :pull => :up)
led=PiPiper::Pin.new(:pin => 18, :direction => :out)
def tap
led.on
puts "button TAPPED"
led.off
#system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py")
end

def bootup
  led.on
puts " bootup script"
led.off
#system("/usr/bin/python","/home/pi/Python-Thermal-Printer/startup.py")
end

def halt
  led.on
puts "button HELD: shutdown script"
led.off
#system("/usr/bin/python","/home/pi/Python-Thermal-Printer/shutdown.py")
#system("/bin/sync")
#system("/sbin/shutdown -h now")
end


PiPiper.watch :pin => 23,:trigger => :rising do
  puts "Button pressed changed from #{last_value} to #{value}"
  t=Time.now
puts "t is #{t} time is #{Time.now}"
end
PiPiper.watch :pin => 23,:trigger => :falling do
  delta = Time.now.to_f - t.to_f
puts "t is #{t} time is #{Time.now} delta is #{delta.inspect} usec "
  t=Time.now
  puts "Button released: changed from #{last_value} to #{value} delta: #{delta}"
  tap if 0.1 <= delta and delta < 0.5 
  halt  if 1 < delta and  delta < 20
  puts "debounce" if 0.1 > delta 
end
sleep 5
bootup
led.off
PiPiper.wait