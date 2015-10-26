module EstormLottoGem
  class TelcoLoad < LogInstantwin
    def get_path
      "api/pulsa.json"
    end
   
    def telco_load(src,telco,value)
      build_postdata('telco_load', src)
      res=merge_perform(self.postdata,{value: value,telco: telco})
      res
    end
    
    
   
  end
end