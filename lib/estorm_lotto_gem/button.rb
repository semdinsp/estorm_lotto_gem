require 'pi_piper'
module EstormLottoGem
  class Button
    include PiPiper

    def self.tap
    puts "button TAPPED"
    end
    def self.test
      true
    end
    def bootup
    puts " bootup script"
    end
    def self.led_mgr(cmd)
      @@led.on
      cmd
      @@led.off
    end
    def self.held
    puts "button HELD: "
    end
    #ADD MUTEX TO MANAGE TIME
    def manage_buttons
      @@pin=PiPiper::Pin.new(:pin => 23, :pull => :up)
      @@led=PiPiper::Pin.new(:pin => 18, :direction => :out)
      @@t=Time.now
      PiPiper.watch :pin => 23,:trigger => :falling , :pull => :up do
        #puts "Button pressed changed from #{last_value} to #{value}"
        #puts "."
        @@t=Time.now
      end
      PiPiper.watch :pin => 23,:trigger => :rising , :pull => :up do
        delta = Time.now.to_f - @@t.to_f
        @@t = Time.now
        EstormLottoGem::Button.led_mgr(EstormLottoGem::Button.tap()) if 0.03 <= delta and delta < 0.7
        EstormLottoGem::Button.led_mgr(EstormLottoGem::Button.held())  if 2 < delta and  delta < 20
        #puts "debounce" if 0.1 > delta
      end
      sleep 5
      EstormLottoGem::Button.led_mgr(bootup)
      @@led.off
      @@t=Time.now
      PiPiper.wait
    end
  end
end  # module