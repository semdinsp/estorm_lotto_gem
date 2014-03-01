module EstormLottoGem
  class WbBalance < EstormLottoGem::Base
    def get_balance(src)
      build_postdata('wallet_balance', src)
      self.postdata[:message]="balance"
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
  end # clase
end #module