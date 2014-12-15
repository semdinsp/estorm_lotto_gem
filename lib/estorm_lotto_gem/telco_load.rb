module EstormLottoGem
  class TelcoLoad < LogInstantwin
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
    
   
  end
end