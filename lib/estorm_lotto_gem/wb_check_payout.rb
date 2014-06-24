module EstormLottoGem
  class WbCheckPayout < EstormLottoGem::Base
    def check_payout(src,md5,drawdate,drawtype='4d')
      appname="wallet_check_payout_#{drawtype}"
      send_process(md5,src,drawdate,appname)
    end
    def process_payout(src,md5,drawdate,drawtype='4d')
      appname="wallet_process_payout_#{drawtype}"
      send_process(md5,src,drawdate,appname)
    end
    
    def send_process(md5,src,drawdate,appname)
      build_postdata(appname, src)
      message={:md5 => md5.downcase, :drawdate=> drawdate, :source => src}
      self.postdata[:message]=MultiJson.dump(message)
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def print_error
      resString=res.first.inspect.to_s
      system("/usr/bin/python","#{self.python_directory}/print_no_payout.py",resString,seller,drawtype,drawdate,md5,printer_type) if printer_type!= "none"
    end
    def print_free_entry(res,seller,drawtype,drawdate,md5,printer_type='adafruit')
      print "Free entry #{res}"
      system("/usr/bin/python","#{self.python_directory}/print_free_entry.py",res['digits'],res['drawdate'],res['md5short'],printer_type,seller,drawtype)    
    end
    def print_paid_ticket(res,seller,drawtype,drawdate,md5,printer_type='adafruit')
       respstring=""
       puts  "print payouts #{res} class #{res.class}"
       if res.first['success']
         value=res.first['payout']['value']
         valstr="#{value}"
         resString=res.first.inspect.to_s
         system("/usr/bin/python","#{self.python_directory}/print_paid_ticket.py",resString,seller,drawtype,drawdate,md5,valstr,printer_type) if printer_type!= "none"
         print_free_entry(res.first['payout']['freeentry'],seller,drawtype,drawdate,md5,printer_type) if res.first['payout']['freeflag']  
       else
        print_no_payout(res,seller,drawtype,drawdate,md5,printer_type)
      end
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       [resString]
    end
    def print_no_payout(res,seller,drawtype,drawdate,md5,printer_type)
      resString=res.first.inspect.to_s
      system("/usr/bin/python","#{self.python_directory}/print_no_payout.py",resString,seller,drawtype,drawdate,md5,printer_type) if printer_type!= "none"
 
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
         print_no_payout(res,seller,drawtype,drawdate,md5,printer_type)
       end
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       [resString]
    end
    
  end # clase
end #module