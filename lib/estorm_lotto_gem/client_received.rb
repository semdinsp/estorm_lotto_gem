module EstormLottoGem
  class ClientReceived < EstormLottoGem::Base
   # attr_accessor :randgen, :myrange
 


 
  def get_path
    "wallet_transactions/client_received.json"
  end
  
 
  
 
  
   def client_received(src,txid,params={})
     build_postdata(txid, src)
     res=merge_perform(self.postdata,{txid: txid}.merge(params))
     puts "client received res is #{res}"
     res
   end
   def self.mark_received(src,txid,debug=false)
     wb=EstormLottoGem::ClientReceived.new
      wb.set_debug if debug
     Thread.new {   res=wb.client_received(src,txid)
       puts res
         }
   end


   end    # Class
end    #Module