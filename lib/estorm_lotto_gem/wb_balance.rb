module EstormLottoGem
  class WbBalance < EstormLottoGem::Base
    def get_balance(src)
      build_postdata('wallet_balance', src)
      self.postdata[:message]="balance"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    
    def transfer(src,dest,value,pin)
      build_postdata('wallet_transfer', src)
      self.postdata[:message]="transfer"
      self.postdata[:value]=value
      self.postdata[:pin]=pin
      self.postdata[:destination]=dest
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def changepin(oldpin,newpin)
      build_postdata('wallet_changepin', src)
      self.postdata[:oldpin]=oldpin
      self.postdata[:newpin]=newpin
      self.postdata[:message]="changepin"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
  end # class
end #module