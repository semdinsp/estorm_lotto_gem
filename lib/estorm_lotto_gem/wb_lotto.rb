module EstormLottoGem
  class WbLotto4d < EstormLottoGem::Base
    def get_ticket(src,msg="4d",drawtype='4d',ticket_count=1)
      build_postdata("wallet_lotto#{drawtype}", src)
      res=merge_perform(self.postdata,{message: msg,ticket_count: ticket_count})
      res
    end
    
    def get_promotion(src,msg,drawtype='multi',ticket_count=1)
      build_postdata("wallet_promotion", src)
      res=merge_perform(self.postdata,{message: msg,ticket_count: ticket_count})
      res
    end
    
    def get_animal(digits)
      #EstormLottoGem::Constants.get_animal(digits)
      animal=EstormLottoGem::Constants.get_animal(digits)
      animal
    end
    
    def get_digits(drawtype,resp)
      digits="#{resp['digit1']}#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}"
      digits="#{resp['digit2']}#{resp['digit3']}#{resp['digit4']}" if drawtype=='3d'
      digits="#{resp['digit3']}#{resp['digit4']}" if ['2d','shio'].include?(drawtype) 
      digits
    end
    def print_ticket(res,seller,drawtype,printer_type='adafruit')
       resp=res['ticket']
       digits=get_digits(drawtype,resp)
       digits=get_animal(digits) if drawtype=='shio'
       drawdate=resp['drawdate']
       src=resp['customersrc']
       code=resp['md5short']
       exmsgs=resp['resp_extra_messages'] 
       ticketcount="1"
       ticketcount=resp['ticket_count']  if !resp['ticket_count'].nil?
       exmsgs = "none" if exmsgs==nil or exmsgs==""
       txid=""
       EstormLottoTools::Sound.playsound('swiss_be.wav')
       puts "digits #{digits} dd #{drawdate} src #{src} code #{code} msgs #{exmsgs} resp: #{resp} printer #{printer_type}"
       system("/usr/bin/python","#{self.python_directory}/print_ticket.py",digits,drawdate,code,exmsgs,printer_type,seller,drawtype,ticketcount.to_s) if printer_type!= "none"
       
       [digits,drawdate,src,code,exmsgs,txid]
    end
    def wbl_getcombo_data(res,drawtype)
      digits=[]
      codes=[]
      res.each {|resp|  
        if resp['success'] and resp['ticket']!=nil
         digs=get_digits(drawtype,resp['ticket'])
         digits << digs
         codes << resp['ticket']['md5short']
       end   
      }  
      return digits,codes
    end
    def print_combo_ticket(res,seller,drawtype,printer_type='adafruit')
       puts "print combo ticket #{res}"
       digits,codes=wbl_getcombo_data(res,drawtype)
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