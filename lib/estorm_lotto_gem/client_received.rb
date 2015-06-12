module EstormLottoGem
  class ClientReceived < EstormLottoGem::Base
   # attr_accessor :randgen, :myrange
 


 
  def get_path
    "wallet_transactions/client_received.json"
  end

 
  
   def build_postdata(txid, src,params={})
     @postdata={}
     @postdata[:security_code]='12345'
     @postdata[:timestamp]=Time.now.to_s
     @postdata[:hardware_id]=Hwid.systemid
    # @postdata[:auth_token]='EAc9S1JXBN5MXstisRC6'
     @postdata[:auth_token]=self.auth_token
     @postdata[:auth_email]=self.auth_email
     @postdata[:source]=src
     @postdata[:txid]=txid
     @postdata.merge params
     #puts "postdata is #{@postdata}"
     @postdata
   end
  
   def client_received(src,txid,params={})
     build_postdata(txid, src)
     res=merge_perform(self.postdata,params)
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