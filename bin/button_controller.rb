#!/usr/bin/env ruby
delay=30
puts "waiting #{delay} seconds for system to boot and settle down loading pi_piter"
puts "to update run: sudo gem install estorm_lotto_gem  --source https://n6ojjVsAxpecp7UjaAzD@gem.fury.io/semdinsp/"
sleep delay-10
puts "ten seconds left"
sleep 5
puts "starting....."
require 'estorm_lotto_gem'
module EstormLottoGem
  class Button
    def tap
    self.led.on
    puts "button TAPPED"
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py")
    self.led.off
    end

    def bootup
    self.led.on
    puts "bootup script"
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/startup.py")
    self.led.on
    end

    def halt
    self.led.on
    puts "button HELD: shutdown script"
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/shutdown.py")
    system("/bin/sync")
    system("/sbin/shutdown -h now")
    self.led.off
    end
  end   # button class
end

mgr=EstormLottoGem::Button.new
mgr.manage_buttons

