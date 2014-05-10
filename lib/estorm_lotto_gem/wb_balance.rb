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
    def release_cash(src,from_account,value,pin,from_pin)
      build_postdata('wallet_release_cash', src)
      self.postdata[:message]="release_cash"
      self.postdata[:value]=value
      self.postdata[:pin]=pin
      self.postdata[:from_pin]=from_pin
      self.postdata[:from_account]=from_account
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def update_pin(src,oldpin,newpin)
      build_postdata('wallet_update_pin', src)
      self.postdata[:pin]=oldpin
      self.postdata[:newpin]=newpin
      self.postdata[:message]="wallet_update_pin"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
  end # class
end #module