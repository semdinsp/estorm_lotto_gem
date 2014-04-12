module EstormLottoGem
  class WbDrawResults < EstormLottoGem::Base
    def get_results(src,drawtype='4d')
      appname="wallet_draw_results_#{drawtype}"
      build_postdata(appname, src)
      self.postdata[:message]=appname
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    
    def print_results(res,seller,drawtype,printer_type='adafruit')
       respstring=""
       puts  "rpint results #{res} class #{res.class}"
       res['draws'].each { |r| respstring <<  "#{r['drawdate']}: #{r['digits']}\n"   }
       puts "respstring: #{respstring}  printer #{printer_type}"
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_results.py",respstring,seller,drawtype,printer_type,) if printer_type!= "none"
       [respstring]
    end
    
    
   
    def print_ramalan(res,seller,drawtype,printer_type='adafruit')
       respstring=""
       puts  "rpint ramalan #{res} class #{res.class}"
       shiolist=[ "kambing" ,"kuda", "ular", "naga","kalenci","mecan","capi","tikus","monyet","babi","anjing","ayam" ]
       yday=Time.now.yday()
       yday = yday +3 if drawtype=='3d'
       shio=shiolist[yday % shiolist.size]
       r0=res['draws'][0]
       r1=res['draws'][1]
       yest=r0['digits']
       older=r1['digits']
       pastdraws="#{r0['drawdate']}: #{r0['digits']}\n#{r1['drawdate']}: #{r1['digits']}\n"
       
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_ramalan.py",pastdraws,shio,seller,"ekor","kapala",printer_type,seller,drawtype) if printer_type!= "none"
       ["#{shio} pastdraows: #{pastdraws}"]
    end
    
  end # clase
end #module