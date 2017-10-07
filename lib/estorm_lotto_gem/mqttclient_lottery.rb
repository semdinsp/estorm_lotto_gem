

module EstormLottoGem
  class MqttclientLottery  < MqttclientEstorm
    
   
     
     def build_lottery_payload(src,payload)

       finalpayload={"version"=>"1", :hardware_id => Hwid.systemid, :timestamp => Time.now.to_s,
           :source=>  src }
           
       finalpayload= finalpayload.merge payload
       finalpayload[:uuid]=SecureRandom.uuid  if finalpayload[:uuid].nil?
       pretty_print_payload(finalpayload)
       finalpayload
     end
    
    def send_mqtt(config,client,topic,payload={})
        super(config,client,topic,self.build_lottery_payload(config[:source],payload))
    end
    

    
    def self.mqtt_load_balance_topic(app)
      #"loadbalancer"+['1','2'].sample
      "loadbalancer"+['1'].sample
    end
    

   def self.mqtt_lottery_entry_message(appname,ticket_count,d1,d2,d3,d4,d5,d6,options={},env='production')
       topic="lottery/#{env}/#{appname}/#{MqttclientLottery.mqtt_load_balance_topic(appname)}/entry"
       digits = [d1,d2,d3,d4,d5,d6].sort
       payload={ ticket_count: ticket_count, digits: digits}.merge(options)
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
  
   
  
   def self.tms_checkwin_print(msg, seller,title,logo,printer_type="rongta")
     basegem=EstormLottoGem::Base.new
     hashmsg=eval(msg)  # FIX THIS
     options={"prize"=> hashmsg['prize'],"email"=> hashmsg['email'], 'prize_value'=> hashmsg['prize_value'], 'validated'=> hashmsg['validated'],
            'terminal'=> hashmsg['terminal'],'msg'=> hashmsg['msg'],'game'=> hashmsg['game']} 
     puts "options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     options['winner']=hashmsg['winner']
     system("/usr/bin/python","#{basegem.python_directory}/tms_checkwinner.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
 
    
   
    
    
  end
end