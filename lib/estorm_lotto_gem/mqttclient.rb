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
    def get_certdir_root
      '/boot/config/certs'  
    end
    
    
    def setup(identity,env="production",  host = "a36q3zlv5b6zdr.iot.ap-southeast-1.amazonaws.com" )
      certdir=get_certdir_root
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
        :source => identity,
        :keep_alive => 40
      }
     # puts "Configuration is: #{config} cert path #{certdir}"
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
      client.keep_alive =35    # default keep alive
      client.keep_alive = config[:keep_alive]  if !config[:keep_alive].nil? # scott checking keep alive
      puts "mqtt src: #{config[:source]}: connecting #{client.host}:#{client.port}"
      client.connect()
      client
    end
    
    def read_message(config,client,topic,timeout=100)
       message={:success => false}
       puts "mqtt subscribed to topic: #{topic}"
         begin  
           Timeout::timeout(timeout) {  topic,message = client.get(topic)  }
             #topic,message = client.get(topic) 
         rescue Exception => e
           
           msg= "Exception with #{topic} error #{e.message} "
           message={:success => false, :msg => msg }.to_json
           puts msg
           puts "config is #{config.inspect} timeout: #{timeout}"
           puts e.backtrace
         end
         client.unsubscribe(topic)
        return  [ topic, message]
    end
    
    def send_mqtt(config,client,topic,payload)
        puts "mqtt sending topic #{topic} payload size #{payload.to_json.size} [#{Time.now}]"
        client.publish(topic, payload.to_json.to_s)
        return [topic, payload]
    end
    
    
  end
end