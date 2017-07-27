

module EstormLottoGem
  class MqttclientTms  < MqttclientEstorm
    
   
     
     def build_tms_payload(src,payload)

       finalpayload={"version"=>"1", :hardware_id => Hwid.systemid, :timestamp => Time.now.to_s,
           :source=>  src }
           
       finalpayload= finalpayload.merge payload
       finalpayload[:uuid]=SecureRandom.uuid  if finalpayload[:uuid].nil?
       pretty_print_payload(finalpayload)
       finalpayload
     end
    
    def send_mqtt(config,client,topic,payload={})
        super(config,client,topic,self.build_tms_payload(config[:source],payload))
    end
    
    def self.mqtt_send_base_message(payload,env,topic) 
       mq,config,client,src=self.mqtt_common_setup(env)
       readtopic,response =mq.send_message_wait_confirmation(config,client,topic,payload)
       client.disconnect
       response
      
    end
    
   def self.mqtt_send_validation_message(appname,game,list,env='production')
       topic="tms/#{env}/#{appname}/validate"  # is appname correct?
       payload={:game => game, :params => list}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_winnerimport_message(appname,game,list,vendor,order,env='production')
       topic="tms/#{env}/#{appname}/winnerimport"
       payload={:game => game, :list => list, :vendor => vendor,:order => order}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.tms_print(msg, seller,title,printer_type="rongta")
     basegem=EstormLottoGem::Base.new
     hashmsg=eval(msg)  # FIX THIS
     options={"id"=> hashmsg['validation']['id'],'total'=> hashmsg['validation']['total']} if !hashmsg['validation'].nil?
     puts "options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     system("/usr/bin/python","#{basegem.python_directory}/tms_message.py", msg, printer_type,seller,options.to_json,title) if printer_type!= "none"  
   end
    
    
#    def self.mqtt_send_balance_message(env='production')
 #      mq,config,client,src=self.mqtt_common_setup(env)
 #      topic="sms3/#{env}/balance"
#       readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
  #     client.disconnect
  #     response
  #  end
    
   
    
    
  end
end