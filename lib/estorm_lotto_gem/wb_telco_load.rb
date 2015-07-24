module EstormLottoGem
  class WbTelcoLoad <  EstormLottoGem::Base
  
   
    def telco_load(src,telco,value,msg='wallet_telco_load')
      build_postdata(msg, src)
      res=merge_perform(self.postdata,{message: msg,telco: telco,value: value})
      res
    end
    
    def reload(src,telco,pin,master,msg='wallet_telco_reload')
      build_postdata(msg, src)
      res=merge_perform(self.postdata,{message: msg,telco: telco,pin: pin, master: master})
      res
    end
    
    def telco_transfer(src,value,destination,msg='wallet_telco_transfer_telkomcel')
      build_postdata(msg, src)
      res=merge_perform(self.postdata,{message: msg,value: value,destination: destination})
      res
    end
    
    def cashout(src,master,value)
      build_postdata('wallet_cashout', src)
      res=merge_perform(self.postdata,{message: 'wallet_cashout',value: value, master: master})      
      puts "cashout res is #{res}"
      res
    end
    def process_message_vals(res)
      value=" "
      pin=" "
      serial=" "
      telco=" "
      txid=" "
      cost=" "
      msg=" "
      if  !res.first.nil? then
         value=res.first['value'] if  !res.first['value'].nil?
         pin=res.first['pin'] if  !res.first['pin'].nil?
         serial=res.first['serial'] if !res.first['serial'].nil?
         telco=res.first['telco'] if  !res.first['telco'].nil?
         msg=res.first['message'] if  !res.first['message'].nil?
        end 
      txid=res[1]['txid'] if res[1]!=nil 
      cost=res[1]['transaction_fee'] if res[1]!=nil
      [value,pin,serial,telco,txid.split('-').last,cost,msg]
    end
    
    def print_telco_load(res,seller,printer_type='adafruit')
       respstring=""
       value,pin,serial,telco,txid,cost,msg = process_message_vals(res)
       
       puts  "print telco load#{res} class #{res.class}"
       ['Customer Copy',"Merchant Copy"].each { |label|
         system("/usr/bin/python","#{self.python_directory}/print_telco_load.py",
                  pin,seller,value.to_s,printer_type,msg,txid,telco,serial,label) if printer_type!= "none"    
                pin='***********'
       }
         
       respstring="Sold #{value} Telco: #{telco}\ntxid: #{txid} serial #{serial} cost: #{cost}\nMessage: #{msg}".gsub("\n","</p></p>")
       [respstring]
        
    end
    
    def print_cashout(res,seller,printer_type='adafruit')
       respstring=""
       value,pin,serial,telco,txid,cost,msg = process_message_vals(res)
       txid = res.first['txid'] if res.first!=nil
       master=res.first['destination'] if res.first!=nil
       puts  "print reload load#{res} class #{res.class}"
       ['Customer Copy','Merchant Copy'].each { |label|
         system("/usr/bin/python","#{self.python_directory}/print_cashout.py",
                  seller,value.to_s,printer_type,txid,master,label) if printer_type!= "none"    
       }
         
       respstring="Cashout: #{value} Txid:  #{txid}\nmaster #{master}".gsub("\n","</p></p>")
       [respstring]
        
    end
    def print_reload(res,seller,printer_type='adafruit')
       respstring=""
       value,pin,serial,telco,txid,cost,msg = process_message_vals(res)
       
       puts  "print reload load#{res} class #{res.class}"
       ['Customer Copy'].each { |label|
         system("/usr/bin/python","#{self.python_directory}/print_reload.py",
                  pin,seller,value.to_s,printer_type,telco,serial,label) if printer_type!= "none"    
       }
         
       respstring="Reload #{value} Telco: #{telco}\nserial #{serial}\nMessage: #{msg}".gsub("\n","</p></p>")
       [respstring]
        
    end
   
  end
end