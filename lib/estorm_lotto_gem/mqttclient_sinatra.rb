module EstormLottoGem
  class MqttclientSinatra  < MqttclientEstorm
    
    def self.mqtt_common_setup(env)
      src='sinatra-app'
      mq,config,client=self.create(src,env)
      return [mq,config,client,src]
    end
  
    def get_certdir_root
      '/app/config/certs'  
    end
    
  end
end   #module