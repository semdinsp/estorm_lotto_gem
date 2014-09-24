require 'bcrypt'
module EstormLottoGem
  class WbBalance < EstormLottoGem::Base
    def get_balance(src)
      build_postdata('wallet_balance', src)
      self.postdata[:message]="balance"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def update_value_pin(value,pin)
      self.postdata[:value]=value
      self.postdata[:pin]=pin
      self.postdata[:api_balance]='encrypted_pin'
      #self.postdata[:encrypted_pin]=BCrypt::Password.new(pin)
    end
    def transfer(src,dest,value,pin,options={})
      build_postdata('wallet_transfer', src)
      self.postdata[:message]="transfer"
      self.update_value_pin(value,pin)
      self.postdata[:destination]=dest
      self.postdata=self.postdata.merge(options)
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def get_session(src,pin)
      build_postdata('wallet_get_session', src)
      self.postdata[:message]="wallet_get_session"
      self.update_value_pin("0",pin)
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def customer_list(src)
      build_postdata('wallet_misc_custs', src)
      self.postdata[:message]="wallet_misc_custs"
      self.update_value_pin("0",'pin')
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def release_cash(src,from_account,value,pin,from_pin)
      build_postdata('wallet_release_cash', src)
      self.postdata[:message]="release_cash"
      self.update_value_pin(value,pin)
      self.postdata[:from_pin]=from_pin
      self.postdata[:encrypted_frompin]=BCrypt::Password.create(from_pin)
      self.postdata[:from_account]=from_account
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
    def update_pin(src,oldpin,newpin)
      build_postdata('wallet_update_pin', src)
      self.update_value_pin("0",oldpin)
      self.postdata[:newpin]=newpin
      self.postdata[:encrypted_newpin]=BCrypt::Password.create(newpin)
      self.postdata[:message]="wallet_update_pin"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
   
  end # class
end #module