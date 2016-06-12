module EstormLottoGem
  class SmsNotification < EstormLottoGem::Base
    
    def  self.send_sms_msg(postdata)
         smsMgr=EstormLottoGem::SmsNotification.new
         smsMgr.send_sms_msg(postdata)
      end
    
      def  send_sms_msg(postdata)
             post=self.build_postdata( postdata[:message],  postdata[:source])
             res=self.merge_perform(post,postdata)
             puts "message response: #{res}"
             res
        end
    
      def  get_path
         "text_applications/send_message_params.json"
      end
     
  end
end

