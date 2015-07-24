#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
require 'I18n'
# needs upgrade to thor
# test_cli.rb get_balance --host=Scotts-MacBook-Pro.local:8080 --source=6590683565
class TestLog < Thor
    
    
    desc "log", "log instant win result"
    option :source, :required => true
    option :prize, :required => true
    option :game, :required => true
    option :message
    option :host, :required => true
    option :debug
    def log
      logger=EstormLottoGem::LogInstantwin.new
      logger.set_host(options[:host])
      logger.set_debug if options[:debug]=='true'
      logger.log_result(options[:source],options[:prize],options[:message],options[:game])
     end
     
     desc "trx", "log transaction"
     option :source, :required => true
     option :value, :required => true
     option :txid, :required => true
     option :service_name, :required => true
     option :data
     option :host, :required => true
     option :debug
     def trx
       logger=EstormLottoGem::ZTransaction.new
       logger.set_host(options[:host])
       logger.set_debug if options[:debug]=='true'
       res=logger.log_trx(options[:source],options[:value],options[:txid],options[:data],options[:service_name])
       puts res
      end
     
     desc "pulsa", "get pulsa pin and serial number"
     option :source, :required => true
     option :telco, :required => true
     option :value, :required => true
     option :host, :required => true
     option :debug
     def pulsa
       load=EstormLottoGem::TelcoLoad.new
       load.set_host(options[:host])
       load.set_debug if options[:debug]=='true'
       res=load.telco_load(options[:source],options[:telco],options[:value])
       puts res
      end
    
      desc "reload_internal", "check pin and get value "
      option :source, :required => true
      option :telco, :required => true
      option :master, :required => true
      option :pin, :required => true
      option :host, :required => true
      option :debug
      def reload_internal
        load=EstormLottoGem::ZLoadPin.new
        load.set_host(options[:host])
        load.set_debug if options[:debug]=='true'
        load.reload(options[:source],options[:telco],options[:pin],options[:master])
       end
       
       desc "reload", "check pin and get value "
       option :source, :required => true
       option :telco, :required => true
       option :master, :required => true
       option :pin, :required => true
       option :host, :required => true
       option :debug
       def reload
         load=EstormLottoGem::WbTelcoLoad.new
         load.set_host(options[:host])
         load.set_debug if options[:debug]=='true'
         res=load.reload(options[:source],options[:telco],options[:pin],options[:master])
         puts "RES is #{res}"
        end
        
        desc "telco_transfer", "transfer value  "
        option :source, :required => true
        option :destination, :required => true
        option :value, :required => true
        option :host, :required => true
        option :debug
        def telco_transfer
          load=EstormLottoGem::WbTelcoLoad.new
          load.set_host(options[:host])
          load.set_debug if options[:debug]=='true'
          res=load.telco_transfer(options[:source],options[:value],options[:destination])
          puts "RES is #{res}"
         end
        
        desc "cashout", "cashout and transfer "
        option :source, :required => true
        option :master, :required => true
        option :value, :required => true
        option :host, :required => true
        option :debug
        def cashout
          load=EstormLottoGem::WbTelcoLoad.new
          load.set_host(options[:host])
          load.set_debug if options[:debug]=='true'
          res=load.cashout(options[:source],options[:master],options[:value])
          puts "RES is #{res}"
         end
   
  end

  TestLog.start(ARGV)