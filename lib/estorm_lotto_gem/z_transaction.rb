module EstormLottoGem
  class ZTransaction < TelcoLoad
    def get_path
      "api/trx.json"
    end
   
    def log_trx(src,value,txid,data,svcname)
      #t.string :log
      #t.string :value
      #t.string :service_name
      #t.string :txid
        build_postdata('trx', src)
        res=merge_perform(self.postdata,{value: value, txid: txid, data: data, service_name: svcname})   #FIX
        res
    end
    
   
  end
end