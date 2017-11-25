

module EstormLottoGem
  class MqttclientEstorm  < Mqttclient
    
    def self.create(identity,env="production",  host = "a36q3zlv5b6zdr.iot.ap-southeast-1.amazonaws.com" )
      # mq=EstormLottoGem::MqttclientEstorm.new
      mq=self.new
      config=mq.setup(identity,env,host )
      client=mq.start(config)
      return [mq,config,client]
     end
     
     def build_estorm_payload(src,payload)

       finalpayload={"version"=>"1", :hardware_id => Hwid.systemid, :timestamp => Time.now.to_s,
           :source=>  src }
           
       finalpayload= finalpayload.merge payload
       finalpayload[:uuid]=SecureRandom.uuid  if finalpayload[:uuid].nil?
       pretty_print_payload(finalpayload)
       finalpayload
     end
    
    def send_mqtt(config,client,topic,payload={})
        super(config,client,topic,self.build_estorm_payload(config[:source],payload))
    end
    
    def pretty_print_payload(payload,debug=false)
       payloadsize=payload.to_json.size
       puts "payload hash key count #{payload.size} payload size bytes: #{payloadsize} "
       puts "payload is: #{payload.to_json}" if payloadsize < 400 or debug
       # puts "payload first 100 is: #{payload.to_json.to_s[1..100]}" if payloadsize > 100
    end
    
    def wait_uuid(config,client,topic,uuid,timeout=60)
      ntopic="#{topic}/#{uuid}"
      topic,response= self.read_message(config,client,ntopic,timeout)
      puts "wait_uuid: topic: #{topic} response: #{response} timeout: #{timeout}"
      return [topic,JSON.parse(response)]
    end
   
    def send_uuid(config,client,topic,src,uuid,payload={})
      ntopic="#{topic}/#{uuid}"
      payload[:confirmuuid]=uuid
      self.send_mqtt(config,client,ntopic,payload)
    end
    
    def send_message_wait_confirmation(config,client,topic,payload={})
      uuid=SecureRandom.uuid
      payload[:uuid]=uuid
      src=config[:source]
      rcvtopic="terminal/#{src}/#{uuid}"
      client.subscribe(rcvtopic)
      puts "sending payload entries: #{payload.size}"
      topic,payload= self.send_mqtt(config,client,topic,payload)
      puts "waiting #{rcvtopic}"
      self.wait_uuid(config,client,"terminal/#{src}",uuid,40)
    end
    
    def self.uuid_confirmatin(dest,confirm,uuid,src="myapp",payload={}, env='production')
       mq,config,client=self.create(src,env)
       topic,payload =mq.send_uuid(config,client,"terminal/#{dest}",uuid,payload)
       
    end
    
    def self.mqtt_send_base_message(payload,env,topic) 
       mq,config,client,src=self.mqtt_common_setup(env)
       readtopic,response =mq.send_message_wait_confirmation(config,client,topic,payload)
       client.disconnect
       response
      
    end
    
    def self.mqtt_load_balance_topic(app='dummy')
      #"loadbalancer"+['1','2'].sample
      "loadbalancer"+['1'].sample
    end
    
    def self.mqtt_common_setup(env)
      wb=EstormLottoTools::ConfigMgr.new
      src=wb.read_config()['identity']
      mq,config,client=self.create(src,env)
      return [mq,config,client,src]
    end
    
  #  def self.mqtt_send_balance_message(env='production')
  #     mq,config,client,src=self.mqtt_common_setup(env)
  #     topic="sms3/#{env}/balance"
  #     readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
  #     client.disconnect
  #     response
  #  end
    
    
    def self.mqtt_send_balance_message(env='production')
       mq,config,client,src=self.mqtt_common_setup(env)
       topic="sms3/#{env}/#{MqttclientEstorm.mqtt_load_balance_topic()}/balance"
       readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
       client.disconnect
       response
    end
    
    def self.mqtt_send_lottery_message(game,entries,tc=1,env='production')
       mq,config,client,src=self.mqtt_common_setup(env)
       topic="sms3/#{env}/#{MqttclientEstorm.mqtt_load_balance_topic()}/lottery"
       payload={game: game,entries: entries, ticket_count: tc}
       readtopic,response =mq.send_message_wait_confirmation(config,client,topic,payload)
       client.disconnect
       response
    end
    
    def self.mqtt_send_edtl_meter(payload,env='production')
       mq,config,client,src=self.mqtt_common_setup(env)
       topic,payload =mq.send_mqtt(config,client,"edtl/#{env}/meter",payload)
       
    end
    
    def self.estorm_lottery_print(jsonmsg, seller,title,logo,printer_type="rongta")
      basegem=EstormLottoGem::Base.new
      system("/usr/bin/python","#{basegem.python_directory}/lottery_ticket.py", jsonmsg.to_json, printer_type,seller,jsonmsg.to_json,title,logo) if printer_type!= "none"  
    end
    
    
  end
end