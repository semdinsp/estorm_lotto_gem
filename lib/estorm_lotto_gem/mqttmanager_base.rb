
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
      puts "mqtt connecting"
      client.connect()
      client
    end

    # ruby-smpp delegate methods


  
    def read_messages(client,config)
      mytopic=config[:topic]
      client.subscribe(mytopic)
      puts "mqtt subscribed to topic: #{mytopic} and all subtopics"
      client.get do |topic,payload|
        # Block is executed for every message received
        begin
           self.message_received(client,config,topic,payload)
         rescue Exception => e
           msg= "Exception with #{topic} #{payload} error is: #{e.inspect} "
           puts msg
           puts e.backtrace
           # msg= "Wrong ASCII Coding Problem sending #{resp.id} #{resp.inspect} msg1: #{msg1} msg2: #{msg2}"
         end
      end
    
    
    end

  


  end
end