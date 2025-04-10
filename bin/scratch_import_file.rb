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
    def publish_to_api(func,list,options,vendor,env)
      tries ||= 3
      # res=EstormLottoGem::MqttclientTms.mqtt_send_winnerimport_message(options[:app],options[:game],list,vendor,options[:order],options,env)
        # self.mqtt_send_winnerimport_message(appname,game,list,vendor,order,options,env='production')
      
      res=EstormLottoGem::MqttclientTms.send(func,options[:app],options[:game],list,vendor,options[:order],options,env)
   
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
    
    def process_csv(func,options)
      count=0
      max=options[:blocksize].to_i
      env=options[:env]
      list=[]
      vendor=options[:vendor]
      
      CSV.foreach(open(options["filename"])) { |row|
       begin
         puts "row is #{row.inspect}"   if options[:debug]=='true'
         if !row.empty?
           prize=row[1].gsub('K','') if !row[1].nil?
           list << { "VIRN" => row[0],"value" => row[1],"prizeValue" => prize} if options[:vendor]=='bzp'
           list << { "serial" => row[0],"pin" => row[0], "value" => 0.5} if options[:vendor]=='heineken'
         end
         count=count+1
         if list.size == max
            puts "\nCOUNT: [#{count}]"
            puts " -------"
            puts "sending block of #{max} count #{count} list size #{list.size}"
            STDOUT.flush
            res=publish_to_api(func,list,options,vendor,env)
            puts res
            list=[]
          end
       end 
       }
       puts "FINAL: sending block of #{max} count #{count} list size #{list.size}"
       res=publish_to_api(func,list,options,vendor,env)
       puts "FAILCOUNT #{res['failcount']} should be zero response: #{res.inspect}"
    end  #porcess csb
    
    
    
  }
  # EXAMPLE
  # scratch_import_file.rb bzpimportwinner --app=scratchlao --game=cat --order=006 --filename=catall.uniq.csv
  # scratch_import_file.rb bzpimportwinner --app=scratchlao --game=moneytree --order=24002 --filename=/Users/scottsproule/Downloads/L0004-24002.csv
  
  # end example
  desc "bzpimportwinner", " bzp import file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  option :app, :required => true
  option :game, :required => true
  option :order, :required => true
  option :filename, :required => true
  option :validate
  option :blocksize, :default => "2000"
  def bzpimportwinner
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    vendor='bzp'
    list=[]
    max=options[:blocksize].to_i
    noptions=options.dup
    noptions[:vendor]='bzp'
    noptions[:env]=env
    process_csv('mqtt_send_winnerimport_message',noptions)
    
  #  count=0
  #  CSV.foreach(open(options["filename"])) { |row|
  #   begin
  #     puts "row is #{row.inspect}"   if options[:debug]=='true'
  #     if !row.empty?
  #       prize=row[1].gsub('K','')
   #      list << { "VIRN" => row[0],"value" => row[1],"prizeValue" => prize}
   #    end
  #     count=count+1
    #   if list.size == max
    #      puts "\nCOUNT: [#{count}]"
    #      puts " -------"
    #      puts "sending block of #{max} count #{count} list size #{list.size}"
    #      STDOUT.flush
    #      res=publish_to_api('mqtt_send_winnerimport_message',list,options,vendor,options[:env])
     #     puts res
      #    list=[]
      #  end
     #end 
    # }
    # puts "FINAL: sending block of #{max} count #{count} list size #{list.size}"
    # res=publish_to_api(stormLottoGem::MqttclientTms.mqtt_send_winnerimport_message,list,options,vendor,env)
    # puts "FAILCOUNT #{res['failcount']} should be zero response: #{res.inspect}"
   
  end
  
  
  #  bin/scratch_import_file.rb heinekenwinner --debug=true --game=heineken --filename=hhtest --order=false
  desc "heinekenwinner", " heinekenwinner import file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  option :game, :required => true
  option :order, :required => true
  option :filename, :required => true
  option :validate
  option :blocksize, :default => "2000"
  def heinekenwinner
    env="production"
    env="development" if options[:debug]=='true'
    
    puts "options are #{options.inspect}"
    vendor='bzp'
    noptions=options.dup
    noptions[:env]=env
    noptions[:app]=""
    noptions[:vendor]='heineken'
    process_csv('mqtt_send_heinekenimport_message',noptions)
   
  end
  
end

 ScratchImportFile.start(ARGV)