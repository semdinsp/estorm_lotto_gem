module EstormLottoGem
  class WbTelcoLoad <  EstormLottoGem::Base
  
   
    def telco_load(src,telco,value,msg='wallet_telco_load')
       merge_data_perform(msg,src,{message: msg,telco: telco,value: value})
    end
    
    def reload(src,telco,pin,master,msg='wallet_telco_reload')
      merge_data_perform(msg,src,{message: msg,telco: telco,pin: pin, master: master})
    end
    
    def telco_transfer(src,value,destination,msg='wallet_telco_transfer_telkomcel')
      merge_data_perform(msg,src,{message: msg,value: value,destination: destination})   
    end
    
   
    def cashout(src,master,value,msg='wallet_cashout')
      merge_data_perform(msg,src,{value: value, master: master})   
      
    end
    def process_value_hash(key,srchash)
      key=' '
      key=srchash[key] if !srchash.nil? and !srchash[key].nil?
      key
    end
    def process_message_vals(res)
         value=process_value_hash('value',res.first)
         pin=process_value_hash('pin',res.first)
         serial=process_value_hash('serial',res.first)
         telco=process_value_hash('telco',res.first)
         msg=process_value_hash('message',res.first)
         txid=process_value_hash('txid',res[1])
         cost=process_value_hash('transaction_fee',res[1])
      
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