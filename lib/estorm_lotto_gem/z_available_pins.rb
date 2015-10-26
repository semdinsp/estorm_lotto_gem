module EstormLottoGem
  class ZGetAvailablePins < TelcoLoad
    def get_path
      "mathematica/post_available_pins.json"
    end
   
    def available_pins(src)
      build_postdata('available_pins', src)
      res=merge_perform(self.postdata,{})
      res
    end
    
    
   
  end
end