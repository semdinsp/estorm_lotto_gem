#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
gem 'mqtt'
require 'mqtt'
require 'estorm_lotto_gem'
require 'json'
require 'csv'


class ScratchImportBooklets  < Thor
  no_commands {
    def publish_to_api(func,list,options,vendor,env)
      tries ||= 3
      # self.mqtt_send_bookletimport_message(appname,game,list,order,options,env='production')
      
     
      res=EstormLottoGem::MqttclientTms.send(func,options[:app],options[:game],list,options[:order],options,env)
   
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
           list << { "carton" => row[0],"booklet_number" => row[1]} 
         end
         count=count+1
         if list.size == max
            puts "\nCOUNT: [#{count}]"
            puts " -------"
            puts "sending block of #{max} count #{count} list size #{list.size}"
            STDOUT.flush
            # self.mqtt_send_bookletimport_message(appname,game,list,order,options,env='production')
            
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
  # scratch_import_booklets.rb bzpimportbooklets  --debug=true --app=timor --game=lafaek --order=003 --filename=invshort.csv --blocksize=200
  # end example
  desc "bzpimportbooklets", " bzp import file booklets and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  option :app, :required => true
  option :game, :required => true
  option :order, :required => true
  option :filename, :required => true
  option :validate
  option :blocksize, :default => "100"
  def bzpimportbooklets
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    vendor='bzp'
    list=[]
    max=options[:blocksize].to_i
    noptions=options.dup
    noptions[:vendor]='bzp'
    noptions[:env]=env
    process_csv('mqtt_send_bookletimport_message',noptions)
    
  
   
  end
  
  
  #  bin/scratch_import_file.rb heinekenwinner --debug=true --game=heineken --filename=hhtest 
  
end

 ScratchImportBooklets.start(ARGV)