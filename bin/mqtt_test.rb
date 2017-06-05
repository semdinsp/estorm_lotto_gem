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
    
    # bin/mqtt_test.rb winnerimport --game=test --debug=true --app=test --vendor=bzp --list='[{"VIRN":"123456","value":"K5000","prizeValue":"5000"}]'

    desc "winnerimport", "import list VIRN, prize, prizeValue"
    option :debug
    option :app, :required => true
    option :game, :required => true
    option :vendor, :required => true
    option :list, :required => true
    def winnerimport
      env="production"
      env="development" if options[:debug]=='true'
      puts "options are #{options.inspect}"
      list =JSON.parse(options[:list])
      res=EstormLottoGem::MqttclientTms.mqtt_send_winnerimport_message(options[:app],options[:game],list,options[:vendor],env)
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