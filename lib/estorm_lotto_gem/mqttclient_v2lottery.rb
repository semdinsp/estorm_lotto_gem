module EstormLottoGem
  class MqttclientV2lottery  <  MqttclientTms
    
   
     
    
  
    

   def self.mqtt_lottery_entry_message(appname,ticket_count,d1="",d2="",d3="",d4="",d5="",d6="",options={},env='production')
       topic="lottery/#{env}/6d/#{appname}/#{self.mqtt_load_balance_topic(appname)}/entry"
       puts "digits are [#{d1} #{d2} #{d3} #{d4} #{d5} #{d6}]"
       digits = [d1,d2,d3,d4,d5,d6].sort
       payload={ ticket_count: ticket_count, digits: digits}.merge(options)
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
  
   def self.mqtt_common_setup(env)
     src='sms-app'
     mq,config,client=self.create(src,env)
     return [mq,config,client,src]
   end 
  
   
   # CAN DELETE I THINK
   def self.mqtt_lottery_print(msg, seller,title,logo,printer_type="rongta")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     
     options={"prize"=> hashmsg['prize'],"email"=> hashmsg['email'], 'prize_value'=> hashmsg['prize_value'], 'validated'=> hashmsg['validated'],
            'terminal'=> hashmsg['terminal'],'msg'=> hashmsg['msg'],'game'=> hashmsg['game']} 
     puts "options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     options['winner']=hashmsg['winner']
     system("/usr/bin/python","#{basegem.python_directory}/tms_checkwinner.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
 
    
   
    
    
  end
end