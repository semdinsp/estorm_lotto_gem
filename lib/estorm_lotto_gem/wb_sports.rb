module EstormLottoGem
  class WbSports < EstormLottoGem::Base
    def get_instantwin(src,msg="instant")
      build_postdata("wallet_sports", src)
      self.postdata[:message]=msg
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def self.teams
      [["Brasil","Brasil"],["Spain","Spain"], ["Barcelona","Barcelona"],["Croatia","Croatia"]]
    end
    def print_instant_first(seller,team,txid,printer_type='adafruit')
      
       msg1=["It is #{team} in the lead by one point","1 minute to go #{team} leads by 1"].sample
       msg2=["Oh no! Yellow card against #{team}", "Penalty kick for #{team}","Red card!","They shoot","The crowd screams but the view is blocked"]
       msgs=[msg1,msg2].join("\n").to_s
        
       system("/usr/bin/python","#{self.python_directory}/print_instant1.py",team,txid,seller,msgs,printer_type) if printer_type!= "none"
       [msgs]
    end
  end # clase
end #module