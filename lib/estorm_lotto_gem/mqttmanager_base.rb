
module EstormLottoGem
  class MQTTmanagerBase



    def start(config)
      client = MQTT::Client.new
      client.host = config[:host]
      client.port = config[:port]
      client.ssl = true
      client.cert_file = config[:certpath]
      client.key_file  = config[:keypath]
      client.ca_file   = config[:rootca]
      client.keep_alive =25    # default keep alive
      client.keep_alive = config[:keep_alive]  if !config[:keep_alive].nil?
      puts "mqtt mqttmanager base connecting"
      client.connect()
      client
    end

    # ruby-smpp delegate methods

    def build_cert_paths(certdir,appName)
        puts "#{Time.now}: Starting MQTT Gateway."
        env=Rails.env
        rootCAPath = certdir+"/root-CA.crt"
        identity="/"+ appName
        certificatePath = certdir+identity+".cert.pem"
        privateKeyPath = certdir+identity+".private.key"
        puts "#{Time.now}: Paths: #{certificatePath}."
        STDOUT.flush 
        [env, certificatePath, privateKeyPath,rootCAPath]
    end

  
    def read_messages(client,config)
      mytopic=config[:topic]
      client.subscribe(mytopic)
      puts "mqttmanagerbase subscribed to topic: #{mytopic} and all subtopics about to loop for messages"
      STDOUT.flush
      
      client.get do |topic,payload|
        # Block is executed for every message received
        begin
           self.message_received(client,config,topic,payload)
         rescue Exception => e
           msg= "Exception with #{topic} #{payload} error is: #{e.inspect} "
           puts msg
           puts e.backtrace
         end
      end
    
    
    end

  


  end
end