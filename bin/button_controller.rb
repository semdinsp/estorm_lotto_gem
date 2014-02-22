#!/usr/bin/env ruby
delay=30
puts "waiting #{delay} seconds for system to boot and settle down loading pi_piter"
# puts "to update run: sudo gem install estorm_lotto_gem  --source https://n6ojjVsAxpecp7UjaAzD@gem.fury.io/semdinsp/"
sleep delay-10
puts "ten seconds left"
sleep 5
puts "starting....."
require 'estorm_lotto_gem'
module EstormLottoGem
  class Button
    def self.tap
    puts "button TAPPED"
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py")
    end

    def bootup
    puts "bootup script"
    # needs to call python script with following to setup GPIO board.
    # ledPin       = 18
    #buttonPin    = 23
    # Use Broadcom pin numbers (not Raspberry Pi pin numbers) for GPIO
    #GPIO.setmode(GPIO.BCM)
    # Enable LED and button (w/pull-up on latter)
    #GPIO.setup(ledPin, GPIO.OUT)
    #GPIO.setup(buttonPin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/startup.py")
    end

    def self.held
    puts "button HELD: shutdown script"
    wb=EstormLottoGem::WbBalance.new
    wb.set_host('Scotts-MacBook-Pro.local:8080')
    src='6590683565'
    res=wb.get_balance(src)
    balance='unknown'
    balance=res['balance'] if res['success']
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/shutdown.py", balance)
    system("/bin/sync")
    system("/sbin/shutdown -h now")
    end
  end   # button class
end

mgr=EstormLottoGem::Button.new
mgr.manage_buttons

