module EstormLottoGem
  class WbLotto4d < EstormLottoGem::Base
    def get_ticket(src,msg="4d",drawtype='4d')
      build_postdata("wallet_lotto#{drawtype}", src)
      res=merge_perform(self.postdata,{message: msg})
      res
    end
    def print_ticket(res,seller,drawtype,printer_type='adafruit')
       resp=res['ticket']
       digits="#{resp['digit1']}#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}"
       digits="#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}" if drawtype=='3d'
       digits="#{resp['digit3']}#{resp['digit4']}" if drawtype=='2d'
       
       
       drawdate=resp['drawdate']
       src=resp['customersrc']
       code=resp['md5short']
       exmsgs=resp['resp_extra_messages'] 
       exmsgs = "none" if exmsgs==nil or exmsgs==""
       txid=""
       puts "digits #{digits} dd #{drawdate} src #{src} code #{code} msgs #{exmsgs} resp: #{resp} printer #{printer_type}"
       #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_ticket.py",digits,drawdate,code,exmsgs,printer_type,seller,drawtype) if printer_type!= "none"
       [digits,drawdate,src,code,exmsgs,txid]
    end
  end # clase
end #module