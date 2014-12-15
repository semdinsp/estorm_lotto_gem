module EstormLottoGem
  class WbTelcoLoad <  EstormLottoGem::Base
  
   
    def telco_load(src,telco,value,msg='wallet_telco_load')
      build_postdata(msg, src)
      res=merge_perform(self.postdata,{message: msg,telco: telco,value: value})
      #puts "postdata #{self.postdata}"
      res
    end
    
    def print_telco_load(res,seller,printer_type='adafruit')
       respstring=""
       value=res.first['value'] if res.first!=nil
       pin=res.first['pin'] if res.first!=nil
       serial=res.first['serial'] if res.first!=nil
       telco=res.first['telco'] if res.first!=nil
       txid=res[1]['txid'] if res[1]!=nil
       cost=res[1]['transaction_fee'] if res[1]!=nil
       msg="thank you from Telkcomcel"
       puts  "print telco load#{res} class #{res.class}"
         system("/usr/bin/python","#{self.python_directory}/print_telco_load.py",
                pin,seller,value.to_s,printer_type,msg,txid,telco,serial) if printer_type!= "none"    
       respstring="Sold #{value} Telco: #{telco}\nPin #{pin}\ntxid: #{txid} serial #{serial} cost: #{cost}".gsub("\n","</p></p>")
       [respstring]
        
    end
   
  end
end