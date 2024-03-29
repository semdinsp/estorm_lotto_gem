module EstormLottoGem
  class LogInstantwin < EstormLottoGem::Base
    def get_path
      "api/create.json"
    end
    def auth_token
      at='7utxzqSPRdc6hvFsAjbL'
      at='K3wLZy-Nz5nPVUxysPX2' if @debug
      at
    end
   
    def initialize
       @host= 'estorm-event.herokuapp.com'
       @debug=false
    end
    def set_debug
      set_host('localhost:5555')
      @debug=true
      # @@host= 'localhost:8083'
    end
    def log_result(src,prize,message,game)
      build_postdata('log_instant_win', src)
      self.postdata[:prize]=prize
      self.postdata[:message]=message
      self.postdata[:gamename]=game
      #puts "postdata #{self.postdata}"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
  
   
  end
end