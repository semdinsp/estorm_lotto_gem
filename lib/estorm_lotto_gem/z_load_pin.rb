module EstormLottoGem
  class ZLoadPin < TelcoLoad
    def get_path
      "api/reload.json"
    end
   
    def reload(src,telco,pin)
       telco_load(src,telco,pin)
    end
    
   
  end
end