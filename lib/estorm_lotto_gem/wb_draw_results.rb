module EstormLottoGem
  class WbDrawResults < EstormLottoGem::Base
    def get_results(src,drawtype='4d')
      appname="wallet_draw_results_#{drawtype}"
      send_process(src,appname)
    end
    
    def teds_simple_reporting(src,reporttype='reporting')
      appname="teds_simple_#{reporttype}"
      send_process(src,appname)
    end
    def teds_sold_out(src,msg='4d')
      appname="wallet_sold_out"
      send_process(src,appname,msg)
    end
    def send_process(src,appname,msg=nil)
      build_postdata(appname, src)
      self.postdata[:message]=msg || appname
      res=self.perform(self.action_url,self.postdata)
      res
    end
    def wbp_sold_values(res)
      sold='none'
      soldouts=""
      drawdate=""
      sold=res.first['soldout'] || {}
      drawdate=res.first['soldout']['draw']
      sold.delete('draw') 
  #puts "SOLD is #{sold}"
      sold.each { |k,v| soldouts << "#{k} count #{v}\n" }
      soldouts << "No sold out numbers" if sold.empty?
      return sold,drawdate,soldouts
    end
    def print_sold_out(res,seller,draw_type,printer_type='adafruit')
       respstring=""
       #puts  "print sold out reportings  #{res} class #{res.class}"
      
       sold,drawdate,soldouts=wbp_sold_values(res) if res.first!=nil and res.first['soldout']!=nil 
       system("/usr/bin/python","#{self.python_directory}/soldout.py",draw_type,seller,soldouts,printer_type,drawdate) if printer_type!= "none"
       respstring="Sold out: #{res.inspect.to_s} sold list: #{soldouts}  drawdate: #{drawdate}"
       [respstring]
    end
    def print_simple_reporting(res,seller,report_type,printer_type='adafruit')
       respstring=""
       puts  "print simple reportings  #{res} class #{res.class}"
       respstring="Summary Report: #{res.inspect.to_s}"
       self.print_transaction(res.inspect.to_s,seller,"Revenue Report: #{report_type.capitalize}",printer_type)
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       [respstring]
    end
    def build_result_string(draw)
      rstring=""
      rstring << "#{draw['drawdate']}: #{draw['digits']}\n" 
      rstring << "second: #{draw['second']}: third: #{draw['third']}\n" if !draw['second'].nil?
      ptypes=['starter','consolation']
      ptypes.each { |prizetype|   rstring << "#{prizetype.camelcase}: #{draw[prizetype]}\n" if !draw[prizetype].nil?  }
      rstring << "\n" if !draw['consolation'].nil?
      rstring
    end
    
    def print_results(res,seller,drawtype,printer_type='adafruit')
       respstring=""
       puts  "rpint results #{res} class #{res.class}"
       res['draws'].each { |r| respstring <<  build_result_string(r)
          }
       puts "respstring: #{respstring}  printer #{printer_type}"
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       EstormLottoTools::Sound.playsound('kidscheering.wav')
       
       system("/usr/bin/python","#{self.python_directory}/print_results.py",respstring,seller,drawtype,printer_type) if printer_type!= "none"
       [respstring]
    end
    
    def wbp_adjust_year(drawtype)
      yday=Time.now.yday()
      adj={'4d'=>0,'2d'=>6,'3d'=>3,'combo'=>9,'combo10'=>13, 'sing' => 5, 'jogu' => 7}
      yday = yday + adj[drawtype]
      yday =yday-364 if yday > 365
      yday
    end
    def wbp_get_yest(draws)
      r0=draws[0]
      r1=draws[1]
      yest=older='1234'
      yest=r0['digits'] if !r0['digits'].nil?
      older=r1['digits'] if !r1['digits'].nil?
      return yest,older,r0,r1
    end
    def wbp_ekor_kapala(res)
      draws=res['draws']
      yest,older,r0,r1= wbp_get_yest(draws)
      ekor= 120 - yest[-2].to_i*10 - yest[-1].to_i
      kapala= older[0].to_i*10 - yest[0].to_i*10 - yest[1].to_i + older[1].to_i
      return ekor,kapala,r0,r1
    end
   
    def print_ramalan(res,seller,drawtype,printer_type='adafruit')
       respstring=""
       puts  "rpint ramalan #{res} class #{res.class}"
       shiolist=[ "kambing" ,"kuda", "ular", "naga","kelinci","macan","sapi","tikus","monyet","babi","anjing","ayam" ]
       yday=wbp_adjust_year(drawtype)
       shio=shiolist[yday % shiolist.size]
       ekor,kapala,r0,r1=wbp_ekor_kapala(res)
       pastdraws="#{r0['drawdate']}: #{r0['digits']}\n#{r1['drawdate']}: #{r1['digits']}\n"
       rama="#{rand(0..9)}#{rand(0..9)}#{rand(0..9)}#{rand(0..9)}#{rand(0..9)}"
       EstormLottoTools::Sound.playsound('kidscheering.wav')
   #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_ramalan.py",pastdraws,shio,"#{ekor.abs}","#{kapala.abs}",printer_type,seller,drawtype,rama) if printer_type!= "none"
       ["#{shio} pastdraows: #{pastdraws}"]
    end
    
  end # clase
end #module