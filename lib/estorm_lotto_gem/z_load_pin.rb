module EstormLottoGem
  class ZLoadPin < TelcoLoad
    def get_path
      "api/reload.json"
    end
   
    def reload(src,telco,pin,master)
        build_postdata('reload', src)
        res=merge_perform(self.postdata,{master: master,pin: pin,telco: telco})
        res

    end
    
   
  end
end
