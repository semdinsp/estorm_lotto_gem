#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
gem 'mqtt'
require 'mqtt'
require 'estorm_lotto_gem'
require 'json'
require 'csv'

module EstormLottoGem
  class Mqttclient

    def setup(identity,env="production",  host = "a36q3zlv5b6zdr.iot.ap-southeast-1.amazonaws.com" )
      certdir=get_certdir_root
      rootCAPath = certdir+"/root-CA.crt"
      tempid='6590683565'
      certificatePath = certdir+"/"+tempid+".cert.pem"
      privateKeyPath = certdir+"/"+tempid+".private.key"
      config = {
        :host => host,
        :port => 8883,
        :env => env,
        :rootca => rootCAPath,
        :certpath => certificatePath,
        :keypath => privateKeyPath,
        :source => identity,
        :keep_alive => 40
      }
     # puts "Configuration is: #{config} cert path #{certdir}"
      config
    end
  end
  
  class MqttclientEstorm  < Mqttclient
    def self.mqtt_common_setup(env)
      #wb=EstormLottoTools::ConfigMgr.new
     # src=wb.read_config()['identity']
      src=$identity
      mq,config,client=self.create(src,env)
      return [mq,config,client,src]
    end
    
  end
 
  
end

class LaoImportWinners < Thor
  no_commands {
    def publish_to_api(func,list,options,vendor,env)
      tries ||= 3
      # res=EstormLottoGem::MqttclientTms.mqtt_send_winnerimport_message(options[:app],options[:game],list,vendor,options[:order],options,env)
     # res=EstormLottoGem::MqttclientTms.mqtt_send_validation_message(appname,params["game"],virns.to_json.to_s,env)
      
      res=EstormLottoGem::MqttclientTms.send(func,options[:app],options[:game],list.to_json.to_s,env)
   
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
      list={}
      vendor=options[:vendor]
      ncount=0
      bcount=1
      #      CSV.foreach(open(options["filename"],{col_sep: ";", headers: true, return_headers: false })) { |row|

      CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
       begin
         puts "row is #{row.inspect}"   if options[:debug]=='true'
         
         if !row.empty?
           ncount=ncount +1
           list["virn#{ncount}"]=row["TICKET_SERIALNO"] 
          end
          list[:count]=ncount
         if list.size == max
            puts "\nCOUNT: [#{bcount}]"
            puts " -------"
            puts "sending block of #{max} count #{bcount} list size #{list.size}"
            STDOUT.flush
            res=publish_to_api(func,list,options,vendor,env)
            puts res
            list={}
            ncount=0
            bcount=bcount+1
            
          end
       end 
       }
       puts "FINAL: sending block of #{max} count #{bcount} list size #{list.size}"
       res=publish_to_api(func,list,options,vendor,env)
       puts "FAILCOUNT #{res['failcount']} should be zero response: #{res.inspect}"
    end  #porcess csb
    
    
    
  }
  # EXAMPLE
  # bin/lao_import_winners.rb laoolddbwinners --debug=true --distributor=test --filename=/Users/scott/Documents/5\ businesses/2\ binomial\ investments/laos/scratch\ card\ lao\ data/testsmall.csv  --app=timor  --blocksize=300
  #MAX BLOCKSIXE 300
  # 
  # end example
  desc "laoolddbwinners", " lao import file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  option :app, :required => true
  #option :game, :required => true
  option :distributor, :required => true
  option :filename, :required => true
  option :blocksize, :default => "100"
  def laoolddbwinners
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    vendor='bzp'
    list=[]
    max=options[:blocksize].to_i
    noptions=options.dup
    noptions[:vendor]='bzp'
    noptions[:env]=env
    $identity=options[:distributor]
    process_csv('mqtt_send_validation_message',noptions)
    
  
   
  end
  
  # lao_import_winners.rb  loaduserids --debug=true --filename=userids.csv 
  desc "loaduserids", " lao import file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  #option :game, :required => true
  option :filename, :required => true
  def loaduserids
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    require File.expand_path('./config/environment', "./") 
    
    
    
    CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
     begin
       puts "row is #{row.inspect}"   
       
       if !row.empty?
         CreateDistributor.new({email: row['proposedemail'],name: row['proposedname'],oldid: row['oldid'],  password: row['password']}).perform
         
        end
           
     end 
     }
  
   
  end
  
  #lao_import_winners.rb  loadbookletdata --debug=true --filename=booklet.csv 
  desc "loadbookletdata", " lao import file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  #option :game, :required => true
  option :filename, :required => true
  def loadbookletdata
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    require File.expand_path('./config/environment', "./") 
    
    #INDEXBOX,FULLBOOKNO,ORDERNO,GAMENO,BOOKLETNO,INVOICE_ID,DATE_INVOICE,OLD_DEALER_ID,NEW_DEALER_ID

    # self.bulk_installation_assign(oldid,order,gameref,booklet)
    
    CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
     begin
       puts "row is #{row.inspect}"   
       
       if !row.empty?
         Booklet.bulk_installation_assign(row['NEW_DEALER_ID'],row['ORDERNO'],row['GAMENO'],row['BOOKLETNO'])
           
        end
           
     end 
     }
  
   
  end
  
  
  #  bin/scratch_import_file.rb heinekenwinner --debug=true --game=heineken --filename=hhtest --order=false
 
  
end

 LaoImportWinners.start(ARGV)