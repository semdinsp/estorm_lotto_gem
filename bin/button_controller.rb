#!/usr/bin/env ruby
delay=30
puts "waiting #{delay} seconds for system to boot and settle down loading pi_piter"
sleep delay-10
puts "ten seconds left"
sleep 5
puts "starting....."
require 'pi_piper'

include PiPiper

t=Time.now
def tap
puts "button TAPPED"
system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py")
end

def bootup
puts "bootup script"
system("/usr/bin/python","/home/pi/Python-Thermal-Printer/startup.py")
end

def halt
puts "shutdown script"
system("/usr/bin/python","/home/pi/Python-Thermal-Printer/shutdown.py")
system("/bin/sync")
system("/sbin/shutdown -h now")
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
  tap if 0.008 <= delta and delta < 0.5 
  halt  if 1 < delta and  delta < 20
  puts "debounce" if 0.008 > delta 
end
sleep 5
bootup
PiPiper.wait