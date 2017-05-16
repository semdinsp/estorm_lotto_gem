

module EstormLottoGem
  class MqttclientTms  < MqttclientEstorm
    
   
     
     def build_tms_payload(src,payload)

       finalpayload={"version"=>"1", :hardware_id => Hwid.systemid, :timestamp => Time.now.to_s,
           :source=>  src, }
           
       finalpayload= finalpayload.merge payload
       finalpayload[:uuid]=SecureRandom.uuid  if finalpayload[:uuid].nil?
       puts "final payload is: #{finalpayload.to_json}"
       finalpayload
     end
    
    def send_mqtt(config,client,topic,payload={})
        super(config,client,topic,self.build_tms_payload(config[:source],payload))
    end
    
  
    
  #  def self.mqtt_send_balance_message(env='production')
  #     mq,config,client,src=self.mqtt_common_setup(env)
  #     topic="sms3/#{env}/balance"
  #     readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
  #     client.disconnect
  #     response
  #  end
    
    
#    def self.mqtt_send_balance_message(env='production')
 #      mq,config,client,src=self.mqtt_common_setup(env)
 #      topic="sms3/#{env}/balance"
#       readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
  #     client.disconnect
  #     response
  #  end
    
   
    
    
  end
end