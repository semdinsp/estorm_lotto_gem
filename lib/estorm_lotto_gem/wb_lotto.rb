module EstormLottoGem
  class WbLotto4d < EstormLottoGem::Base
    def get_ticket(src,msg="4d")
      build_postdata('wallet_lotto4d', src)
      self.postdata[:message]=msg
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def print_ticket(res,printer_type='adafruit')
       resp=res['ticket']
       digits="#{resp['digit1']}#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}"
       drawdate=resp['drawdate']
       src=resp['customersrc']
       code=resp['md5short']
       msgs=resp['resp_extra_messages']
       txid=""
       puts "digits #{digits} dd #{drawdate} src #{src} code #{code} msgs #{msgs} resp: #{resp}"
       system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,msgs,printer_type) 
       [digits,drawdate,src,code,msgs,txid]
    end
  end # clase
end #module