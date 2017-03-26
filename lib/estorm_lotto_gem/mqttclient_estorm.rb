

module EstormLottoGem
  class MqttclientEstorm  < Mqttclient
    
    def self.create(identity,env="production",  host = "a36q3zlv5b6zdr.iot.ap-southeast-1.amazonaws.com" )
      mq=EstormLottoGem::MqttclientEstorm.new
      config=mq.setup(identity,env,host )
      client=mq.start(config)
      return [mq,config,client]
     end
     
     def build_estorm_payload(src,payload)

       finalpayload={"version"=>"1", :hardware_id => Hwid.systemid, :timestamp => Time.now.to_s,
           :source=>  src, }
           
       finalpayload= finalpayload.merge payload
       finalpayload[:uuid]=SecureRandom.uuid  if finalpayload[:uuid].nil?
       puts "final payload is: #{finalpayload.to_json}"
       finalpayload
     end
    
    def send_mqtt(config,client,topic,payload={})
        super(config,client,topic,self.build_estorm_payload(config[:source],payload))
    end
    
    def wait_uuid(config,client,topic,uuid,timeout=40)
      ntopic="#{topic}/#{uuid}"
      topic,response= self.read_message(config,client,ntopic,timoeout=40)
      puts "wait_uuid: topic: #{topic} response: #{response}"
      return [topic,JSON.parse(response)]
    end
   
    def send_uuid(config,client,topic,src,uuid,payload={})
      ntopic="#{topic}/#{uuid}"
      payload[:confirmuuid]=uuid
      self.send_mqtt(config,client,ntopic,payload)
    end
    
    def send_message_wait_confirmation(config,client,topic,payload={})
      payload={}
      uuid=SecureRandom.uuid
      payload[:uuid]=uuid
      src=config[:source]
      rcvtopic="terminal/#{src}/#{uuid}"
      client.subscribe(rcvtopic)
      puts "sending: #{payload}"
      topic,payload= self.send_mqtt(config,client,topic,payload)
      puts "waiting #{rcvtopic}"
      self.wait_uuid(config,client,"terminal/#{src}",uuid,40)
    end
    
    def self.uuid_confirmatin(dest,confirm,uuid,src="myapp",payload={}, env='production')
       mq,config,client=MqttclientEstorm.create(src,env)
       topic,payload =mq.send_uuid(config,client,"terminal/#{dest}",uuid,payload)
       
    end
    def self.mqtt_common_setup(env)
      wb=EstormLottoTools::ConfigMgr.new
      src=wb.read_config()['identity']
      mq,config,client=MqttclientEstorm.create(src,env)
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
       topic="sms3/#{env}/balance"
       readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
       client.disconnect
       response
    end
    
    def self.mqtt_send_edtl_meter(payload,env='production')
       mq,config,client,src=self.mqtt_common_setup(env)
       topic,payload =mq.send_mqtt(config,client,"edtl/#{env}/meter",payload)
       
    end
    
    
  end
end