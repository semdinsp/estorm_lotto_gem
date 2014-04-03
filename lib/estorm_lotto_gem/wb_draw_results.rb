module EstormLottoGem
  class WbDrawResults < EstormLottoGem::Base
    def get_results(src,drawtype='4d')
      build_postdata('wallet_draw_results', src)
      self.postdata[:message]="wallet_draw_results"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    
    def print_results(res,seller,drawtype,printer_type='adafruit')
       respstring=" "
       puts  "rpint results #{res} class #{res.class}"
       res['draws'].each { |r| respstring <<  "#{r['drawdate']}: #{r['digits']}\n"   }
       puts "respstring: #{respstring}  printer #{printer_type}"
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_results.py",respstring,seller,drawtype,printer_type,) if printer_type!= "none"
       [respstring]
    end
    
  end # clase
end #module