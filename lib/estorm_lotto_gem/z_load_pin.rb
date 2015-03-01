module EstormLottoGem
  class ZLoadPin < TelcoLoad
    def get_path
      "api/reload.json"
    end
   
    def reload(src,telco,pin,master)
        build_postdata('reload', src)
        self.postdata[:telco]=telco
        self.postdata[:pin]=pin
        self.postdata[:master]=master
        #puts "postdata #{self.postdata}"
        res=self.perform(self.action_url,self.postdata)
        puts "res is #{res}"
        res

    end
    
   
  end
end