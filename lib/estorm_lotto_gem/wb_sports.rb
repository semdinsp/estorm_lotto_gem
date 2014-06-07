module EstormLottoGem
  class WbSports < EstormLottoGem::Base
    def sports_instantwin(src,msg="wallet_sports_instant")
      build_postdata("wallet_sports_instant", src)
      self.postdata[:message]=msg
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def self.teams
      [["Spain","Spain"], ["Barcelona","Barcelona"],["Croatia","Croatia"],["Brasil","Brasil"]]
    end
    def print_instant_first(seller,team,txid,printer_type='adafruit')
      
       msg1=["It is #{team} in the lead by one point","1 minute to go #{team} leads by 1"].sample
       msg3=["#{team} shoots","The crowd screams but my view is blocked","Goal!"].sample
       
       msg2=["Oh no! Yellow card against #{team}", "Penalty kick for #{team}","Red card!","They shoot","The crowd screams but the view is blocked"].sample
       msgs=[msg1,msg2,msg3].join("\n").to_s
        
       system("/usr/bin/python","#{self.python_directory}/print_instant1.py",team,txid,seller,msgs,printer_type) if printer_type!= "none"
       [msgs]
    end
    def print_results(res,seller,team,txid,printer_type='adafruit')
       respstring=""
       puts  "print sports results #{res} class #{res.class}"
       score=["1","2","3","4","6","8"].sample
       success=["#{team} remains in the lead by #{score} points","You won. Game over! #{team} leads by #{score} point","Last minute penalty kick #{team} WINS!"].sample
       failure=["Opponents beat #{team} by #{score} points. Sorry!","Penalty kick! #{team} LOST","MVP goes to other team keeper for saving #{score} goals"].sample
       msg=failure
       msg=success if res!=nil and res['prize'] > 0.1
       respstring="#{msg} team #{team} prize #{res['prize']}" #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_sports.py",respstring,seller,team,txid,printer_type,res['prize'].to_s ) if printer_type!= "none"
       [respstring]
    end
  end # clase
end #module