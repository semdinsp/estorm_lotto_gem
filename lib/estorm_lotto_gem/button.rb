require 'pi_piper'
module EstormLottoGem
  class Button
    include PiPiper
    def tap(led)
    led.on
    puts "button TAPPED"
    led.off
    #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py")
    end
    def test
      true
    end
    def bootup(led)
    led.on
    puts " bootup script"
    led.off
    #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/startup.py")
    end

    def halt(led)
    led.on
    puts "button HELD: shutdown script"
    led.off
    #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/shutdown.py")
    #system("/bin/sync")
    #system("/sbin/shutdown -h now")
    end
    def manage_buttons
     
      pin=PiPiper::Pin.new(:pin => 23, :pull => :up)
      led=PiPiper::Pin.new(:pin => 18, :direction => :out)
      t=Time.now
      PiPiper.watch :pin => 23,:trigger => :falling , :pull => :up do
        #puts "Button pressed changed from #{last_value} to #{value}"
        #puts "."
        t=Time.now
      end
      PiPiper.watch :pin => 23,:trigger => :rising , :pull => :up do
        delta = Time.now.to_f - t.to_f
        t=Time.now
        #puts "t is #{t} time is #{Time.now} delta is #{delta.inspect} usec "
        #puts "delta is #{delta}"
        #puts "Button released: changed from #{last_value} to #{value} delta: #{delta}"
        tap(led) if 0.03 <= delta and delta < 0.7
        halt(led)  if 2 < delta and  delta < 20
        #puts "debounce" if 0.1 > delta
      end
      sleep 5
      bootup(led)
      led.off
      t=Time.now
      PiPiper.wait
    end
  end
end  # module