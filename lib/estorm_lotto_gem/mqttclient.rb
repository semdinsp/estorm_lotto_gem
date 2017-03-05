require 'json'
require 'hwid'
require "mqtt"

module EstormLottoGem
  class MqttClient
    
    def setup(identity,env="production",  host = "a36q3zlv5b6zdr.iot.ap-southeast-1.amazonaws.com" )
      certdir='/boot/config/certs'
      rootCAPath = certdir+"/root-CA.crt"
      certificatePath = certdir+"/"+identity+".cert.pem"
      privateKeyPath = certdir+"/"+identity+".private.key"
      config = {
        :host => host,
        :port => 8883,
        :env => env,
        :rootca => rootCAPath,
        :certpath => certificatePath,
        :keypath => privateKeyPath
      }
      puts "Configuration is: #{config} cert path #{certdir}"
      config
    end
    
    def start(config)
      client = MQTT::Client.new
      client.host = config[:host]
      client.port = config[:port]
      client.ssl = true
      client.cert_file = config[:certpath]
      client.key_file  = config[:keypath]
      client.ca_file   = config[:rootca]
      puts "mqtt connecting"
      client.connect()
      client
    end
    
    def send_mqtt(config,client,topic,payload)
        puts "mqtt sending topic #{topic} payload #{payload}"
        client.publish(topic, payload.to_json.to_s)
    end
    
    
  end
end