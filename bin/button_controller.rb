#!/usr/bin/env ruby
delay=20
puts "waiting #{delay} seconds for system to boot and settle down loading pi_piter"
# puts "to update run: sudo gem install estorm_lotto_gem  --source https://n6ojjVsAxpecp7UjaAzD@gem.fury.io/semdinsp/"
sleep delay-10
puts "ten seconds left"
sleep 5
puts "starting....."
require 'estorm_lotto_gem'
require 'estorm_lotto_tools'
module EstormLottoGem
  class Button
    def self.config
    end
    def self.tap
    puts "button TAPPED"
    wb=EstormLottoGem::WbLotto4d.new
    params=wb.get_config
    wb.set_host(params['wallethost'])
   # wb.set_host('Scotts-MacBook-Pro.local:8080')
   # src='6590683565'
    src=params['identity']
    res=wb.get_ticket(src)
    digits,drawdate,src,code,msgs,txid = wb.print_ticket(res.first) if res.first['success']
    wb.print_msg(res.first['error'])  if !res.first['success']
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
    params=wb.get_config
    wb.set_host(params['wallethost'])
    src=params['identity']
    res=wb.get_balance(src)
    balance='unknown'
    balance=res.first['balance'] if res.first['success']
    wb.print_msg(res.first['error'])  if !res.first['success']
    system("/usr/bin/python","/home/pi/Python-Thermal-Printer/shutdown.py", balance)
    system("/bin/sync")
    system("/sbin/shutdown -h now")
    end
  end   # button class
end

mgr=EstormLottoGem::Button.new
mgr.manage_buttons

