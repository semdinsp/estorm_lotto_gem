module EstormLottoGem
  class WbCheckPayout < EstormLottoGem::Base
    def check_payout(src,md5,drawdate,drawtype='4d')
      appname="wallet_check_payout_#{drawtype}"
      build_postdata(appname, src)
      message={:md5 => md5, :drawdate=> drawdate}
      self.postdata[:message]=MultiJson.dump(message)
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    
    def print_payout(res,seller,drawtype,drawdate,md5,printer_type='adafruit')
       respstring=""
       puts  "print payouts #{res} class #{res.class}"
       if res.first['success']
         value=res.first['payout']['value']
         valstr="#{value}"
         resString=res.first.inspect.to_s
         system("/usr/bin/python","#{self.python_directory}/winning_ticket.py",resString,seller,drawtype,drawdate,md5,valstr,printer_type) if printer_type!= "none"
       else
         resString=res.first.inspect.to_s
         system("/usr/bin/python","#{self.python_directory}/print_no_payout.py",resString,seller,drawtype,drawdate,md5,printer_type) if printer_type!= "none"
       end
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       [resString]
    end
    
  end # clase
end #module