require 'json'
require 'hwid'
require 'rubygems'
begin
  require 'mqtt'
rescue LoadError
  puts 'Mqtt not installed fix this if needed'
  # error handling code here
end
require 'timeout'

module EstormLottoGem
  class Mqttclient
    
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
        :keypath => privateKeyPath,
        :source => identity
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
    
    def read_message(config,client,topic,timeout=40)
       message={:success => false}
       puts "mqtt subscribed to topic: #{topic}"
         begin  
           Timeout::timeout(timeout) {  topic,message = client.get(topic)  }
             #topic,message = client.get(topic) 
         rescue Exception => e
           msg= "Exception with #{topic} errrr #{e.inspect} "
           puts msg
           puts e.backtrace
           # msg= "Wrong ASCII Coding Problem sending #{resp.id} #{resp.inspect} msg1: #{msg1} msg2: #{msg2}"
         end
         client.unsubscribe(topic)
        return  [ topic, message]
    end
    
    def send_mqtt(config,client,topic,payload)
        puts "mqtt sending topic #{topic} payload #{payload}"
        client.publish(topic, payload.to_json.to_s)
        return [topic, payload]
    end
    
    
  end
end