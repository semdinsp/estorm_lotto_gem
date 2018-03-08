#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
gem 'mqtt'
require 'mqtt'
require 'estorm_lotto_gem'
require 'json'


class MqttTest < Thor
  
    desc "balance_mqtt", "get balance via mqtt"
    option :source, :required => true
    option :debug
    def balance_mqtt
      puts "getting balance via mqtt protocol"
      mq=EstormLottoGem::Mqttclient.new
      env='production'
      env = 'development' if options[:debug]=='true'
      id=options[:source]
      config=mq.setup(id,env )
      client=mq.start(config)
      res=mq.send_mqtt(config,client,"sms3/#{env}/balance",{:source=>id, :uuid => SecureRandom.uuid})
      puts res
    end
    
    desc "validate", "validate a list of virn serial numbers"
    option :debug
    option :app, :required => true
    option :game, :required => true
    option :list, :required => true
    def validate
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      list =JSON.parse(options[:list])
      res=EstormLottoGem::MqttclientTms.mqtt_send_validation_message(options[:app],options[:game],list,env)
      puts res
    end
    
    #bin/mqtt_test.rb lottery --ticket_count=1 --game=632 --entries=1,2,3,4,5,6 --debug=true
    desc "lottery", "lottery ticket"
    option :debug
    option :ticket_count, :required => true
    option :game, :required => true
    option :entries, :required => true
    def lottery
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      e=options[:entries].split(',')
      puts "entries are #{e.inspect}"
  #    mqtt_lottery_entry_message(appname,ticket_count,d1,d2,d3,d4,d5,d6,options={},env='production')
      res=EstormLottoGem::MqttclientV2lottery.mqtt_lottery_entry_message(options[:game],options[:ticket_count],e[0],e[1],e[2],e[3],e[4],e[5],'srctest',{},env)
      puts res
    end
    
    #bin/mqtt_test.rb check_lottery_winner --md5code=1 --game=632  --debug=true
    
    desc "check_lottery_winner", "lottery check winner"
    option :debug
    option :md5code, :required => true
    option :game, :required => true
    def check_lottery_winner
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
  
      res=EstormLottoGem::MqttclientEstorm.mqtt_check_lottery_winner_message(options[:game],options[:md5code],{},env)
      puts res
    end
    
    desc "sms3lottery", "lottery ticket"
    option :debug
    option :ticket_count, :required => true
    option :game, :required => true
    option :entries, :required => true
    def sms3lottery
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      e=options[:entries].split(',')
      puts "entries are #{e.inspect}"
  #    mqtt_lottery_entry_message(appname,ticket_count,d1,d2,d3,d4,d5,d6,options={},env='production')
      res=EstormLottoGem::MqttclientEstorm.mqtt_send_lottery_message(options[:game],options[:entries],options[:ticket_count],env)
      puts res
    end
    
    desc "transfer", "transfer destination value"
    option :debug
    option :destination, :required => true
    option :value, :required => true
    def transfer
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
  #    mqtt_lottery_entry_message(appname,ticket_count,d1,d2,d3,d4,d5,d6,options={},env='production')
      res=EstormLottoGem::MqttclientEstorm.mqtt_send_transfer_message(options[:destination],options[:value],env)
      puts res
    end
     
    #  bin/mqtt_test.rb  statistics --game=625 --msg_type=draw_results --debug=true

    desc "statistics_lottery", "lottery statistics"
    option :debug
    option :game, :required => true
    option :msg_type, :required => true
    def statistics_lottery
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      params={}
      res=EstormLottoGem::MqttclientEstorm.mqtt_send_lottery_statistics_message(options[:game],options[:msg_type],params,env)
      puts res
    end
    
    # bin/mqtt_test.rb winnerimport --game=test --debug=true --app=test --vendor=bzp --list='[{"VIRN":"123456","value":"K5000","prizeValue":"5000"}]'

    desc "winnerimport", "import list VIRN, prize, prizeValue"
    option :debug
    option :app, :required => true
    option :game, :required => true
    option :order, :required => true
    option :vendor, :required => true
    option :list, :required => true
    def winnerimport
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      list =JSON.parse(options[:list])
      res=EstormLottoGem::MqttclientTms.mqtt_send_winnerimport_message(options[:app],options[:game],list,options[:vendor],options[:order],env)
      puts res
    end
    
    desc "terminal_lookup", "lookup terminal"
    option :debug
    option :app, :required => true
  
    def terminal_lookup
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      res=EstormLottoGem::MqttclientTms.mqtt_send_terminallookup_message(options[:app],options,env)
      puts res
    end
    
    desc "check_winner", "check winner via virn"
    option :debug
    option :app, :required => true
    option :virn, :required => true
  
    def check_winner
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      res=EstormLottoGem::MqttclientTms.mqtt_send_checkwinner_message(options[:app],options[:virn],options,env)
      puts res
    end
    
    desc "balance", "simple balance on production system"
    option :debug
    def balance
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      res=EstormLottoGem::MqttclientEstorm.mqtt_send_balance_message(env)
      puts res
    end
    
  end
  
  MqttTest.start(ARGV)