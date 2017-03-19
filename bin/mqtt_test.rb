#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
gem 'mqtt'
require 'mqtt'
require 'estorm_lotto_gem'


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
      mq.send_mqtt(config,client,"sms3/#{env}/balance",{:source=>id, :uuid => SecureRandom.uuid})
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