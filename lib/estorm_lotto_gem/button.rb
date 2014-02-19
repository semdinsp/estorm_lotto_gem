require 'pi_piper'
module EstormLottoGem
  class Button
    include PiPiper
    attr_accessor :led, :pin, :t
    def self.tap
    self.led.on
    puts "button TAPPED"
    self.led.off
    end
    def self.test
      true
    end
    def self.bootup
    self.led.on
    puts " bootup script"
    self.led.off
    end

    def self.held
    self.led.on
    puts "button HELD: "
    self.led.off
    end
    def manage_buttons
      self.pin=PiPiper::Pin.new(:pin => 23, :pull => :up)
      self.led=PiPiper::Pin.new(:pin => 18, :direction => :out)
      @t=Time.now
      EstormLottoGem::Button.watch :pin => 23,:trigger => :falling , :pull => :up do
        #puts "Button pressed changed from #{last_value} to #{value}"
        #puts "."
        @t=Time.now
      end
      EstormLottoGem::Button.watch :pin => 23,:trigger => :rising , :pull => :up do
        delta = Time.now.to_f - @t.to_f
        #@t = Time.now
        EstormLottoGem::Button.tap() if 0.03 <= delta and delta < 0.7
        EstormLottoGem::Button.held()  if 2 < delta and  delta < 20
        #puts "debounce" if 0.1 > delta
      end
      sleep 5
      bootup
      self.led.off
      PiPiper.wait
    end
  end
end  # module