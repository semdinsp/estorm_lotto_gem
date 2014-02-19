require 'pi_piper'
module EstormLottoGem
  class Button
    include PiPiper
    attr_accessor :led, 
    def self.tap
    @@led.on
    puts "button TAPPED"
    @@led.off
    end
    def self.test
      true
    end
    def bootup
    @@led.on
    puts " bootup script"
    @@led.off
    end

    def self.held
    @@led.on
    puts "button HELD: "
    @@led.off
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
        EstormLottoGem::Button.tap() if 0.03 <= delta and delta < 0.7
        EstormLottoGem::Button.held()  if 2 < delta and  delta < 20
        #puts "debounce" if 0.1 > delta
      end
      sleep 5
      bootup
      @@led.off
      @@t=Time.now
      PiPiper.wait
    end
  end
end  # module