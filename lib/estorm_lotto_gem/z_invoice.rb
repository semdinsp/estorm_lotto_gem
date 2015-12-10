module EstormLottoGem
  class ZInvoice < TelcoLoad
    def get_path
      "api/invoice.json"
    end
   
    def invoice(src,value,invoice,txid)
        build_postdata('invoice', src)
        res=merge_perform(self.postdata,{invoice: invoice,value: value,txid: txid})
        res

    end
    
   
  end
end
