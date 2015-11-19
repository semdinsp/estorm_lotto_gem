module EstormLottoGem
  class ZProcessPayment < TelcoLoad
    def get_path
      "api/process_payment.json"
    end
   
    def process_payment(src,txid,msisdn,game)
      #t.string :log
      #t.string :value
      #t.string :service_name
      #t.string :txid
        build_postdata('process_payment', src)
        res=merge_perform(self.postdata,{ txid: txid, msisdn: msisdn, game: game})   #FIX
        res
    end
    
   
  end
end