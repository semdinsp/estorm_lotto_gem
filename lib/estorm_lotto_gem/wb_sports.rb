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
      [["Brazil","Brazil"],["Croatia","Croatia"],["Mexico","Mexico"],["Cameroon","Cameroon"],["Spain","Spain"],
      ["Netherlands","Netherlands"],["Chile","Chile"],["Australia","Australia"],["Greece","Greece"],["Japan","Japan"],
      ["Cote D'Ivoire","Cote D'Ivoire"],["Uraguay","Uraguay"],["Costa Rica","Costa Rica"],["England","England"],["Italy","Italy"],
      ["Switzerland","Switzerland"],["Ecuador","Ecuador"],["France","France"],["Honduras","Honduras"],["Argentina","Argentina"],["Iran","Iran"],["Bosnia-Herzagovina","Bosnia-Herzagovina"],["Nigeria","Nigeria"],
      ["Germany","Germany"],["Portugal","Portugal"],["Ghana","Ghana"],["USA","USA"],["Beligium","Beligium"],
      ["Algeria","Algeria"],["Russia","Russia"],["Korea","Korea"],["Brazil","Brazil"]]
    end
    def print_instant_first(seller,team,txid,printer_type='adafruit')
       teams=EstormLottoGem::WbSports.teams
       teams.delete([team,team])
       @opponents=teams.sample.first
       msg0=["It is #{team} versus #{@opponents}"].sample
       msg1=["It is #{team} in the lead by one point","1 minute to go #{team} leads by 1"].sample
       msg3=["#{team} shoots","#{@opponents} shoots","The crowd screams but my view is blocked","Goal!"].sample
       
       msg2=["Oh no! Yellow card against #{team}", "Penalty kick for #{team}","Red card!","They shoot","The crowd screams but the view is blocked"].sample
       msgs=[msg0,msg1,msg2,msg3].join("\n").to_s
        
       system("/usr/bin/python","#{self.python_directory}/print_instant1.py",team,txid,seller,msgs,printer_type) if printer_type!= "none"
       @oldmsg=msgs
       [msgs]
    end
    def print_results(res,seller,team,txid,printer_type='adafruit')
       respstring=""
       puts  "print sports results #{res} class #{res.class}"
       score=["1","2","3","4","6","8"].sample
       success=["#{team} remains in the lead by #{score} points","You won. Game over! #{team} leads #{@opponents} by #{score} point","Last minute penalty kick #{team} WINS!"].sample
       failure=["#{@opponents} wins in sudden death","#{@opponents} beat #{team} by #{score} points. Sorry!","Penalty kick by #{@opponents}! #{team} LOST","MVP goes to #{@opponents} team keeper for saving #{score} goals"].sample
       msg=failure
       winner=""
       if res!=nil and res['prize'] > 0.1
         winner="WINNER:"
          msg="#{winner} #{success}"
        end
        #system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_ticket.py",digits,drawdate,code,exmsgs,printer_type) if printer_type!= "none"
       system("/usr/bin/python","#{self.python_directory}/print_sports.py",msg,seller,team,txid,printer_type,res['prize'].to_s ) if printer_type!= "none"
       respstring="#{@oldmsg}\n#{winner} #{team} versus #{@opponents} #{msg} prize #{res['prize']}".gsub("\n","</p></p>")
       [respstring]
    end
  end # clase
end #module