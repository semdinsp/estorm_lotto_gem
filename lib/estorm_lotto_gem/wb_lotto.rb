module EstormLottoGem
  class WbLotto4d < EstormLottoGem::Base
    def get_ticket(src,msg="4d")
      build_postdata('wallet_lotto4d', src)
      self.postdata[:message]=msg
      res=self.perform(self.action_url,self.postdata)
      puts "res is #{res}"
      res
    end
  end # clase
end #module