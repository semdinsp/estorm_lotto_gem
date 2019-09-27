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
  
    # lao_import_winners.rb  loadbookletdata --debug=trueff --filename=userids.csv 

  desc "loadbookletdata", " lao booklet data size of chunks.  Validate flag validates entries"
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
    count=0
    CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
     begin
       count=count+1
       puts ""
       puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
       puts "[count: #{count}] row is #{row.inspect} "   
       
       if !row.empty? and row['NEW_DEALER_ID']!="NULL"
            begin
              Booklet.bulk_installation_assign(row['NEW_DEALER_ID'],row['LOTNO'],"00#{row['GAMENO']}",row['BOOKLETNO'],row['REAL_OLD_DEALER_ID'],row) 
            rescue RuntimeError
              u=User.find(row['NEW_DEALER_ID'].to_i)
              flag=u.oldid==0
              u.oldid=row['OLD_DEALER_ID']
              u.save if flag
            end
          
        end
           
     end 
     }
  
   
  end
  
  # lao_import_winners.rb  laowinners --debug=trueff --filename=userids.csv 

desc "laowinners", " lao import file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
option :debug
#option :game, :required => true
option :filename, :required => true
def laowinners
  env="production"
  env="development" if options[:debug]=='true'
  puts "options are #{options.inspect}"
  require File.expand_path('./config/environment', "./") 
  
  # TICKET_INDEXKEYDT, TICKET_BILLRC, TICKET_LOTNO[order],TICKET_GAMENO[game],TICKET_SERIALNO[virn],TICKET_PRICE[prize],TICKET_CARDNO[booklet],TICKET_BILLSALE,REAL_OLD_DEALER_ID,OLD_DEALER_ID, NEW_DEALER_ID
    #2061248,00001/0119DL,006,5,006005312322512,30000.00,NULL,00002/0518HO,3015,3015,51
  count=0
  list={}
  currentuser=-1
  tempcount=0
  oldid=0
  CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
   begin
     count=count+1
     puts ""
     puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
     puts "[count: #{count} tempcount: #{tempcount}] row is #{row.inspect} "   
     tempcount=tempcount+1
     tuser=row['NEW_DEALER_ID']
     currentuser=tuser if currentuser==-1
     oldid=row['REAL_OLD_DEALER_ID']
     
     flag= currentuser!=tuser
     flag=true if tempcount==1500
     if flag 
       begin
         list['count']=tempcount
         puts "loading #{currentuser}  list: #{list.inspect}"
         
         Validation.bulk_load_winners(currentuser,oldid,list)
       rescue RuntimeError
         puts "exception RuntimeError"
       end
       list={}
       tempcount=1
     end
     currentuser=tuser
     # orig      if Winner.by_virn(row['TICKET_SERIALNO'][0..-2]).not_validated.size>0

     if !row.nil? and !row['TICKET_SERIALNO'].nil? and Winner.by_virn(row['TICKET_SERIALNO'][0..-2]).not_validated.size>0
       list["virn#{tempcount}"]=row['TICKET_SERIALNO']
       list["serial#{tempcount}"]=row['TICKET_CARDNO']
     end
         
   end 
   }
   list['count']=tempcount
   
   Validation.bulk_load_winners(currentuser,oldid,list)
   

 
end

# lao_import_winners.rb  laofixdates --debug=trueff --filename=userids.csv 


desc "laofixdates", " lao fix dates of winners and validations"
option :debug
#option :game, :required => true
option :filename, :required => true
def laofixdates
  env="production"
  env="development" if options[:debug]=='true'
  puts "options are #{options.inspect}"
  require File.expand_path('./config/environment', "./") 
  
  # TICKET_INDEXKEYDT, TICKET_BILLRC, TICKET_LOTNO[order],TICKET_GAMENO[game],TICKET_SERIALNO[virn],TICKET_PRICE[prize],TICKET_CARDNO[booklet],TICKET_BILLSALE,REAL_OLD_DEALER_ID,OLD_DEALER_ID, NEW_DEALER_ID
    #2061248,00001/0119DL,006,5,006005312322512,30000.00,NULL,00002/0518HO,3015,3015,51
    
    #Ticket bill rc
    #TICKET_INDEXKEYDT,TICKET_BILLRC,TICKET_LOTNO,TICKET_GAMENO,TICKET_SERIALNO,TICKET_PRICE,TICKET_CARDNO,TICKET_BILLSALE,BILL_DATERC,REAL_OLD_DEALER_ID,OLD_DEALER_ID,NEW_DEALER_ID
  count=0
  list={}
  currentuser=-1
  tempcount=0
  oldid=0
  CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
   begin
     count=count+1
     printflag=[true,false,false,false,false,false,false,false,false].sample
     if printflag
       puts ""
       puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
       puts "[count: #{count} tempcount: #{tempcount}] row is #{row.inspect} " 
     end  
     begin
       billdate=row['BILL_DATERC']
       billmemo="#{row['TICKET_BILLRC']} : #{row['TICKET_BILLSALE']}"
       virn=row['TICKET_SERIALNO']
       w=Winner.find_by_virn(virn[0..-2])
       if !w.nil?
          w.memo=billmemo
          w.redemption_time=billdate
          val=w.validation
          val.created_at=billdate
          w.save
          val.save
          puts "updating memo/date #{w.inspect} val date: #{val.created_at}" if printflag
        else
          puts "VIRN not found #{virn}"
       end
     rescue Exception => e
         puts "exception #{billdate}  #{row['TICKET_SERIALNO']} #{e.inspect}"
     end
              
   end 
   }
   puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
   puts "[count: #{count} ]  " 
  
 
end

# lao_import_winners.rb  laofixwinbooks --debug=trueff --filename=userids.csv 


desc "laofixwinbooks", " lao fix books and winners validations"
option :debug
#option :game, :required => true
option :filename, :required => true
def laofixwinbooks
  env="production"
  env="development" if options[:debug]=='true'
  puts "options are #{options.inspect}"
  require File.expand_path('./config/environment', "./") 
  
  # TICKET_INDEXKEYDT, TICKET_BILLRC, TICKET_LOTNO[order],TICKET_GAMENO[game],TICKET_SERIALNO[virn],TICKET_PRICE[prize],TICKET_CARDNO[booklet],TICKET_BILLSALE,REAL_OLD_DEALER_ID,OLD_DEALER_ID, NEW_DEALER_ID
    #2061248,00001/0119DL,006,5,006005312322512,30000.00,NULL,00002/0518HO,3015,3015,51
    
    #Ticket bill rc
    #TICKET_INDEXKEYDT,TICKET_BILLRC,TICKET_LOTNO,TICKET_GAMENO,TICKET_SERIALNO,TICKET_PRICE,TICKET_CARDNO,TICKET_BILLSALE,BILL_DATERC,REAL_OLD_DEALER_ID,OLD_DEALER_ID,NEW_DEALER_ID
  count=0
  list={}
  currentuser=-1
  tempcount=0
  oldid=0
  CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
   begin
     count=count+1
     printflag=[true,false,false,false,false,false,false,false,false].sample
     if printflag
       puts ""
       puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
       puts "[count: #{count} tempcount: #{tempcount}] row is #{row.inspect} " 
     end  
     begin
       book=row['TICKET_CARDNO']
       virn=row['TICKET_SERIALNO']
       w=Winner.find_by_virn(virn[0..-2])
       if !w.nil? and book!='NULL'
          fvirn,game,order =Winner.process_virn(virn)
          b=Booklet.by_game(game).by_order_reference(order).where("serial_number = :serial",{serial: book}).first
          w.booklet=b
          w.save
          puts "updating booklet #{w.inspect} val booklet: #{b.inspect}" if printflag
        else
          puts "VIRN not found #{virn}"
       end
     rescue Exception => e
         puts "exception  #{row['TICKET_SERIALNO']} #{e.inspect}"
     end
              
   end 
   }
   puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
   puts "[count: #{count} ]  " 
  
 
end
  
  
  #lao_import_winners.rb  laoloadstrange --debug=true --filename=booklet.csv   --order=987 --game=test
  desc "laoloadstrange", " lao import strange file VIRN, prize, prizeValue order and blocksize to change size of chunks.  Validate flag validates entries"
  option :debug
  option :order, required: true
  option :game, required: true
  option :filename, :required => true
  def laoloadstrange
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    require File.expand_path('./config/environment', "./") 
    
    game=Game.find_by_name(options[:game])
    count=0
    #INDEXKEY,SERIALNO,PRICE,BILLNO,DATEREC,PRICERL,LOTNO,USERID,STATUS
    #  1,00000161,K20000,00661/1217BT,2017-12-27 00:00:00.000,20000,006,32,1
    order=options[:order]
    CSV.foreach(options["filename"],{col_sep: ",", headers: true, return_headers: false }) { |row|
     begin
       count=count+1
       puts "count: #{count} row is #{row.inspect}"  
       if !row.empty? 
        row['value']=row['PRICE']
       row['prizeValue']=row['PRICE'].gsub("K","")
       row['VIRN']=row["SERIALNO"]
       tmpvirn="#{order}#{game.vendorreference}#{row['VIRN']}"
       w=Winner.find_by_virn(tmpvirn)
       msg=""
         if w.nil?
         #    w.virn="#{order}#{game.vendorreference}#{row['VIRN']}"
         #create if does not exist
         msg="creating #{row}"
           w=Winner.create_from_row(row,game,"",order)
         else
           #update
           msg="updating  #{row}"
           
           w.prize=row['value']
           w.prize_value=row['prizeValue'].to_f 
         end
        w.save if !w.nil?
        puts "action: #{msg} #{w.inspect}" 
      end  #if empty
         
           
     end #BEGIN
     }
  
   
  end
  
  
  #  bin/scratch_import_file.rb heinekenwinner --debug=true --game=heineken --filename=hhtest --order=false
 
  
end

 LaoImportWinners.start(ARGV)