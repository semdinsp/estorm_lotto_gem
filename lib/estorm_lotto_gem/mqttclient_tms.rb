

module EstormLottoGem
  class MqttclientTms  < MqttclientEstorm
    
   
     
     def build_my_payload(src,payload)

       finalpayload={"version"=>"1", :hardware_id => Hwid.systemid, :timestamp => Time.now.to_s,
           :source=>  src }
           
       finalpayload= finalpayload.merge payload
       finalpayload[:uuid]=SecureRandom.uuid  if finalpayload[:uuid].nil?
       pretty_print_payload(finalpayload)
       finalpayload
     end
    
    def send_mqtt(config,client,topic,payload={})
        super(config,client,topic,self.build_my_payload(config[:source],payload))
    end
    
#    def self.mqtt_send_base_message(payload,env,topic) 
#       mq,config,client,src=self.mqtt_common_setup(env)
#       readtopic,response =mq.send_message_wait_confirmation(config,client,topic,payload)
#       client.disconnect
#       response
      
 #   end
    
    def self.mqtt_load_balance_topic(app)
      #"loadbalancer"+['1','2'].sample
      "loadbalancer"+['1'].sample
    end
    
   def self.mqtt_send_validation_message(appname,game,list,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/validate"  # is appname correct?
       payload={:game => game, :params => list}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_winnerimport_message(appname,game,list,vendor,order,options,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/winnerimport"
       payload={:game => game, :list => list, :vendor => vendor,:order => order}
       payload[:validate]="true" if options[:validate]=='true'
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_terminallookup_message(appname,options,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/terminal_lookup"
       payload={time: Time.now}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_creditnote_message(appname,memo,options,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/credit_note"
       payload={time: Time.now, memo: memo}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_checkwinner_message(appname,virn,options,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/check_winner"
       payload={time: Time.now, virn: virn}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.tms_print(msg, seller,title,logo,printer_type="rongta")
     basegem=EstormLottoGem::Base.new
     hashmsg=eval(msg)  # FIX THIS
     options={}
     options={"id"=> hashmsg['validation']['id'],'total'=> hashmsg['validation']['total'],"email"=> hashmsg['email'],
            'wincount'=> hashmsg['wincount'],'failedcount'=> hashmsg['failedcount']} if !hashmsg['validation'].nil?
     puts "TMS Print:options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     winlist="\n"
     hashmsg['winners'].each { |w| winlist << "#{w['virn']} Prize:#{w['prize_value']} Game:#{w['game_id']}\n" } if !hashmsg['winners'].nil?
     options['winlist']=winlist
     system("/usr/bin/python","#{basegem.python_directory}/tms_message.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   def self.tms_print_failed(msg, seller,title,logo,printer_type="rongta")
     basegem=EstormLottoGem::Base.new
     hashmsg=eval(msg)  # FIX THIS
     options={}
     options={"id"=> hashmsg['validation']['id'],"email"=> hashmsg['email'],
           'failedcount'=> hashmsg['failedcount']} if !hashmsg['validation'].nil?
     puts "TMS PRINT FAILED: options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     faillist="\n"
     hashmsg['failed'].each { |f| faillist << "#{f['virn']} Position:#{f['position']} \n" } if !hashmsg['failed'].nil?
     options['faillist']=faillist
     system("/usr/bin/python","#{basegem.python_directory}/tms_fail_message.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   def self.tms_print_credit_note(msg, seller,title,logo,printer_type="rongta")
     basegem=EstormLottoGem::Base.new
     hashmsg=eval(msg)  # FIX THIS
     options={}
     options={"id"=> hashmsg['id'],"email"=> hashmsg['email'],
           'total'=> hashmsg['total']} if !hashmsg['validation'].nil?
     puts "TMS PRINT CREDIT NOTE: options: #{options.inspect} message is class #{msg.class}  : #{msg.inspect}"
     vals="\n"
     hashmsg['validations'].each { |v| vals << "#{v['id']} Total:#{v['total']} \n" } if !hashmsg['validations'].nil?
     options['vals']=vals
     system("/usr/bin/python","#{basegem.python_directory}/tms_fail_message.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
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
   
   # MqttclientTms.tms_print_generic(msg, seller,title,logo,printer_type="rongta")
   def self.tms_print_generic(msg, seller,title,logo,printer_type="rongta")
     basegem=EstormLottoGem::Base.new
     system("/usr/bin/python","#{basegem.python_directory}/tms_generic_message.py", msg, printer_type,seller,title,logo) if printer_type!= "none"  
   end
    
    
#    def self.mqtt_send_balance_message(env='production')
 #      mq,config,client,src=self.mqtt_common_setup(env)
 #      topic="sms3/#{env}/balance"
#       readtopic,response =mq.send_message_wait_confirmation(config,client,topic)
  #     client.disconnect
  #     response
  #  end
    
   
    
    
  end
end