module EstormLottoGem
  class WbTelcoLoad < LogInstantwin
    def get_path
      "api/pulsa.json"
    end
   
    def telco_load(src,telco,value)
      build_postdata('telco_load', src)
      self.postdata[:telco]=telco
      self.postdata[:value]=value
      #puts "postdata #{self.postdata}"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    
    def print_telco_load(res,seller,printer_type='adafruit')
       respstring=""
       value=res.first['value'] if res.first!=nil
       pin=res.first['pin'] if res.first!=nil
       serial=res.first['serial'] if res.first!=nil
       telco=res.first['telco'] if res.first!=nil
       txid=res[1]['txid'] if res[1]!=nil
       puts  "print telco load#{res} class #{res.class}"
         system("/usr/bin/python","#{self.python_directory}/print_telco_load.py",
                pin,seller,value.to_s,printer_type,msg,txid,telco) if printer_type!= "none"    
       respstring="Sold #{value} Telco: #{telco}\nPin #{pin}\ntxid: #{txid}".gsub("\n","</p></p>")
       [respstring]
        
    end
   
  end
end