#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'


class MqttTest < Thor
  
    desc "balance_mqtt", "get balance via mqtt"
    option :source, :required => true
    option :debug
    def balance_mqtt
      puts "getting balance via mqtt protocol"
      mq=EstormLottoGem::MqttClient.new
      env='production'
      env = 'development' if options[:debug]=='true'
      id=options[:source]
      config=mq.setup(id,env )
      client=mq.start(config)
      mq.send_mqtt(config,client,"sms3/#{env}/balance",{:source=>id})
    end
    
  end
  
  MqttTest.start(ARGV)