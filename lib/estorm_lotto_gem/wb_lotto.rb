module EstormLottoGem
  class WbLotto4d < EstormLottoGem::Base
    def get_ticket(src,msg="4d",drawtype='4d')
      build_postdata("wallet_lotto#{drawtype}", src)
      res=merge_perform(self.postdata,{message: msg})
      res
    end
    def get_digits(drawtype,resp)
      digits="#{resp['digit1']}#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}"
      digits="#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}" if drawtype=='3d'
      digits="#{resp['digit3']}#{resp['digit4']}" if drawtype=='2d'
      digits
    end
    def print_ticket(res,seller,drawtype,printer_type='adafruit')
       resp=res['ticket']
       digits=get_digits(drawtype,resp)
       drawdate=resp['drawdate']
       src=resp['customersrc']
       code=resp['md5short']
       exmsgs=resp['resp_extra_messages'] 
       exmsgs = "none" if exmsgs==nil or exmsgs==""
       txid=""
       EstormLottoTools::Sound.playsound('swiss_be.wav')
       puts "digits #{digits} dd #{drawdate} src #{src} code #{code} msgs #{exmsgs} resp: #{resp} printer #{printer_type}"
       system("/usr/bin/python","#{self.python_directory}/print_ticket.py",digits,drawdate,code,exmsgs,printer_type,seller,drawtype) if printer_type!= "none"
       
       [digits,drawdate,src,code,exmsgs,txid]
    end
    def print_combo_ticket(res,seller,drawtype,printer_type='adafruit')
       puts "print combo ticket #{res}"
       digits=[]
       codes=[]
       res.each {|resp|  
         if resp['success'] and resp['ticket']!=nil
          digs=get_digits(drawtype,resp['ticket'])
          digits << digs
          codes << resp['ticket']['md5short']
        end   
       }     
       drawdate=res.first['ticket']['drawdate'] if res.first['ticket']!=nil
       src=res.first['ticket']['customersrc']  if res.first['ticket']!=nil
       txid=""
       exmsgs="none"
       EstormLottoTools::Sound.playsound('swiss_be.wav')
       puts "digits #{digits.inspect.to_s} dd #{drawdate} src #{src} code #{codes.inspect.to_s} printer #{printer_type}"
       system("/usr/bin/python","#{self.python_directory}/print_combo_ticket.py",digits.join(','),drawdate,codes.join(','),exmsgs,printer_type,seller,drawtype) if printer_type!= "none"
       [digits.join(','),drawdate,src,codes.join(','),exmsgs,txid]
    end
  end # clase
end #module