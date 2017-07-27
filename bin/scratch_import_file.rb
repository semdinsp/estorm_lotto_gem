#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
gem 'mqtt'
require 'mqtt'
require 'estorm_lotto_gem'
require 'json'
require 'csv'


class ScratchImportFile < Thor
  no_commands {
    def publish_to_api(list,options,vendor,env)
      tries ||= 3
      res=EstormLottoGem::MqttclientTms.mqtt_send_winnerimport_message(options[:app],options[:game],list,vendor,options[:order],env)
      
    rescue Exception => e
      puts "Exception is #{e.inspect}"
      if (tries -= 1) > 0
        retry
      else
        puts "Failure #{res.inspect}"
      end
    else
      puts "success!"
      puts res
      res
    end
    
  }
  desc "bzpimportwinner", " bzp import file VIRN, prize, prizeValue order"
  option :debug
  option :app, :required => true
  option :game, :required => true
  option :order, :required => true
  option :filename, :required => true
  def bzpimportwinner
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    vendor='bzp'
    list=[]
    max=2500
    count=0
    CSV.foreach(open(options["filename"])) { |row|
     begin
       puts "row is #{row.inspect}"   if options[:debug]=='true'
       if !row.empty?
         prize=row[1].gsub('K','')
         list << { "VIRN" => row[0],"value" => row[1],"prizeValue" => prize}
       end
       count=count+1
       if list.size == max
          puts "sending block of #{max} count #{count} list size #{list.size}"
          res=publish_to_api(list,options,vendor,env)
          puts res
          list=[]
        end
     end 
     }
     puts "FINAL: sending block of #{max} count #{count} list size #{list.size}"
     res=publish_to_api(list,options,vendor,env)
     puts "FAILCOUNT #{res['failcount']} should be zero response: #{res.inspect}"
   
  end
  
end

 ScratchImportFile.start(ARGV)