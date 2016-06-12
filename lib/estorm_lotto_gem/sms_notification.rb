module EstormLottoGem
  class SmsNotification < EstormLottoGem::Base
    
    def  self.send_sms_msg(postdata)
      smsMgr=EstormLottoGem::SmsNotification.new
           resp=false
           resp = smsMgr.perform(smsMgr.action_url,postdata.to_json) #if postdata[:destination][0]=='6'
           resp
      end
    
      def  get_path
         "text_applications/send_message_params.json"
      end
     
  end
end