#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
require 'json'
require 'csv'

class ImportPropertiesCsv < Thor
  
  
  desc "properties_map", " import prperties map files"
  option :debug
  #option :game, :required => true
  option :filename, :required => true
  def properties_map
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    require File.expand_path('./config/environment', "./") 
    
    #INDEXBOX,FULLBOOKNO,ORDERNO,GAMENO,BOOKLETNO,INVOICE_ID,DATE_INVOICE,OLD_DEALER_ID,NEW_DEALER_ID

    # self.bulk_installation_assign(oldid,order,gameref,booklet)
    #NOTE COL_SEP
    count=0
    CSV.foreach(options["filename"],{col_sep: ";", headers: true, return_headers: false }) { |row|
     begin
       count=count+1
       puts ""
       puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
       puts "[count: #{count}] row is #{row.inspect} "   
       
       if !row.empty? 
            begin
              u=User.find(row['ID'])
              u.set_property_value('telephone',row['telephone']) if row['telephone']!=""
              u.set_property_value('sex',row['sex']) if row['sex']!=""
              u.set_property_value('title',row['title']) if row['title']!=""
              
            rescue RuntimeError
              puts "error setting #{count} : #{row}"
            end
          
        end
           
     end 
     }
  
     puts "added #{count} properties"
  end
  
  desc "account_manager", " import account_manager"
  option :debug
  #option :game, :required => true
  option :filename, :required => true
  def account_manager
    env="production"
    env="development" if options[:debug]=='true'
    puts "options are #{options.inspect}"
    require File.expand_path('./config/environment', "./") 
    
    #INDEXBOX,FULLBOOKNO,ORDERNO,GAMENO,BOOKLETNO,INVOICE_ID,DATE_INVOICE,OLD_DEALER_ID,NEW_DEALER_ID

    # self.bulk_installation_assign(oldid,order,gameref,booklet)
    #NOTE COL_SEP
    count=0
    CSV.foreach(options["filename"],{col_sep: ";", headers: true, return_headers: false }) { |row|
     begin
       count=count+1
       puts ""
       puts "------------------------------------[#{Time.now} filename: #{options["filename"]}]"
       puts "[count: #{count}] row is #{row.inspect} "   
       
       if !row.empty? 
            begin
              u=User.find(row['Distributor'])
              m=User.find(row['Account Manager'])
              m.accounts << u
              m.save
              u.save
            rescue RuntimeError
              puts "error assining manager #{count} : #{row}"
            end
          
        end
           
     end 
     }
  
     puts "added #{count} manaers"
  end
  
end

 ImportPropertiesCsv.start(ARGV)