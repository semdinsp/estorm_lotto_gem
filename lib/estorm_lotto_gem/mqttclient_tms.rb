

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
    
 #SCOTT CHECK THIS
 #   def self.mqtt_load_balance_topic(app)
      #"loadbalancer"+['1','2'].sample
 #     "loadbalancer"+['1'].sample
#    end
    
   def self.mqtt_send_validation_message(appname,game,list,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/validate"  # is appname correct?
       payload={:game => game, :params => list}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_winnerimport_message(appname,game,list,order,options,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/winnerimport"
       payload={:game => game, :list => list, :vendor => vendor,:order => order}
       payload[:validate]="true" if options[:validate]=='true'
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_bookletimport_message(appname,game,list,order,options,env='production')
       topic="tms/#{env}/#{appname}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/bookletimport"
       payload={:game => game, :list => list,:order => order}
       payload[:validate]="true" if options[:validate]=='true'
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.mqtt_send_heinekenimport_message(appname,game,list,vendor,order,options,env='production')
       topic="entrylogger/#{env}/#{MqttclientTms.mqtt_load_balance_topic(appname)}/winnerimport"
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
       payload={time: Time.now, virn: virn, serial: options[:serial]}
       MqttclientTms.mqtt_send_base_message(payload,env,topic) 
   end
   
   def self.common_tasks(msg)
     basegem=EstormLottoGem::Base.new
     hashmsg=eval(msg)  # FIX THIS
     options={} 
     [basegem,hashmsg,options]
   end
   
   def self.common_options(id='not set',email="unknown",total=0)
     options={"id"=> id,"email"=> email,"total"=> total, "locale"=>'en'} 
     options
   end
   
   def self.pretty_print_options(options)
     puts "TMS Pretty Print:options: #{options.inspect} "
   end
   
   def self.tms_print(msg, seller,title,logo,printer_type="rongta",locale="en")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     options=MqttclientTms::common_options(hashmsg['validation']['id'],hashmsg['email'],hashmsg['validation']['total']) if !hashmsg['validation'].nil?
     options=options.merge({'wincount'=> hashmsg['wincount'],'locale'=> locale,'failedcount'=> hashmsg['failedcount']}) 
     self.pretty_print_options(options)
     winlist="\n"
     hashmsg['winners'].each { |w| winlist << "#{w['virn']} Prize:#{w['prize_value']} Game:#{w['game_id']}\n" } if !hashmsg['winners'].nil?
     options['winlist']=winlist
     system("/usr/bin/python","#{basegem.python_directory}/tms_message.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   def self.tms_print_validation(msg, seller,title,logo,printer_type="rongta",locale="en")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     options=MqttclientTms::common_options(hashmsg['validation']['id'],hashmsg['email'],hashmsg['validation']['total']) if !hashmsg['validation'].nil?
     options=options.merge({'wincount'=> hashmsg['wincount'],'locale'=> locale,'failedcount'=> hashmsg['failedcount']}) 
     self.pretty_print_options(options)
     winlist="\n"
     #     result[w.game.name][:total]=result[w.game.name][:total]+val
     #   result[w.game.name][val.to_s] = 0 if result[w.game.name][val.to_s].nil?
     puts "CARD SUMMARY #{hashmsg['cardsummary'].inspect}"
     hashmsg['cardsummary'].each { |k,v | 
                          winlist << "Total Validated #{v}\n" if k=="total"
                          winlist << "Game: #{k}\n   Cards: #{v}\n" if k!="total" and v['total']!=0
                                       } if !hashmsg['cardsummary'].nil?
     options['contents']=winlist
     system("/usr/bin/python","#{basegem.python_directory}/tms_validation.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   def self.tms_print_failed(msg, seller,title,logo,printer_type="rongta",locale="en")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     options=MqttclientTms::common_options(hashmsg['validation']['id'],hashmsg['email']) if !hashmsg['validation'].nil?
     options=options.merge({'failedcount'=> hashmsg['failedcount'],'locale'=> locale }) 
     self.pretty_print_options(options)
           
     faillist="\n"
     hashmsg['failed'].each { |f| faillist << "#{f['virn']} Position:#{f['position']} \n" } if !hashmsg['failed'].nil?
     options['faillist']=faillist
     system("/usr/bin/python","#{basegem.python_directory}/tms_fail_message.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   def self.tms_print_credit_note(msg, seller,title,logo,printer_type="rongta",locale='en')
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     options=MqttclientTms::common_options(hashmsg['id'],hashmsg['email'],hashmsg['total'])
     self.pretty_print_options(options)
     vals="\n"
     hashmsg['validations'].each { |v| vals << "Val id: #{v['id']} Total:#{v['total']} \n" } if !hashmsg['validations'].nil?
     options['vals']=vals
     options['locale']=locale
     options['memo']=hashmsg['memo']
     system("/usr/bin/python","#{basegem.python_directory}/tms_credit_note.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   def self.tms_checkwin_print(msg, seller,title,logo,printer_type="rongta", locale="en")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
     options=MqttclientTms::common_options(hashmsg['id'],hashmsg['email'],0)
     options=options.merge({"prize"=> hashmsg['prize'], 'prize_value'=> hashmsg['prize_value'], 'validated'=> hashmsg['validated'],
            'terminal'=> hashmsg['terminal'],'locale'=> locale, 'msg'=> hashmsg['msg'], 'game'=> hashmsg['game'],
            'location'=> hashmsg['location'], 'bookletowner'=> hashmsg['bookletowner']} )
     options['winner']=hashmsg['winner']
     self.pretty_print_options(options)
     system("/usr/bin/python","#{basegem.python_directory}/tms_checkwinner.py", msg, printer_type,seller,options.to_json,title,logo) if printer_type!= "none"  
   end
   
   # MqttclientTms.tms_print_generic(msg, seller,title,logo,printer_type="rongta")
   def self.tms_print_generic(msg, seller,title,logo,printer_type="rongta")
     basegem,hashmsg,options=MqttclientTms::common_tasks(msg)
    # basegem=EstormLottoGem::Base.new
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