module EstormLottoGem
  class MqttclientV2lottery  <  MqttclientTms
    
   
     
    def get_certdir_root
      dir= '/app/config/certs'  
        if   !defined?  Rails
         dir= '/boot/config/certs' 
       else
         dir= 'config/certs' if Rails.env.development?
       end
      dir
    end
  
 
    

   def self.mqtt_lottery_entry_message(appname,ticket_count,d1="",d2="",d3="",d4="",d5="",d6="",csrc="sms-app",options={},env='production')
       topic="lottery/#{env}/6d/#{appname}/#{self.mqtt_load_balance_topic(appname)}/entry"
       puts "digits are [#{d1} #{d2} #{d3} #{d4} #{d5} #{d6}] src: #{csrc}"
       digits =[]
       [d1,d2,d3,d4,d5,d6].each { |d|  digits << d if !d.nil? }
       digits = digits.sort
       payload={ ticket_count: ticket_count, digits: digits, customersrc: csrc }.merge(options)
       self.mqtt_send_base_message(payload,env,topic) 
   end
  
   def self.mqtt_common_setup(env)
     src='sms3-app'
     src='6590683565' if   !defined?  Rails
     mq,config,client=self.create(src,env)
     return [mq,config,client,src]
   end 
  
   
   # CAN DELETE I THINK
   def self.DELETE_mqtt_lottery_print(msg, seller,title,logo,printer_type="rongta")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     
     options={"prize"=> hashmsg['prize'],"email"=> hashmsg['email'], 'prize_value'=> hashmsg['prize_value'], 'validated'=> hashmsg['validated'],
            'terminal'=> hashmsg['terminal'],'msg'=> hashmsg['msg'],'game'=> hashmsg['game']} 
     puts "options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     options['winner']=hashmsg['winner']
     system("/usr/bin/python","#{basegem.python_directory}/tms_checkwinner.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
 
    
   
    
    
  end
end