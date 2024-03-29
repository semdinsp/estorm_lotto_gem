#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
# require 'I18n'   --done by scott
# needs upgrade to thor
# test_cli.rb get_balance --host=Scotts-MacBook-Pro.local:8080 --source=6590683565
class TestCli < Thor
    desc "get_balance", "get balance"
    option :source, :required => true
    option :host, :required => true
    option :debug
    def get_balance
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
       wb.set_debug if options[:debug]=='true'
      res=wb.get_balance(options[:source])
      puts "balance: #{res}"
      res
    end
    
    desc "transfer", "transfer from src to destination"
    option :source, :required => true
    option :host, :required => true
    option :destination, :required => true
    option :pin, :required => true
    option :value, :required => true
    option :debug
    def transfer
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.transfer(options[:source],options[:destination],options[:value],options[:pin])
      res
    end
    
    desc "sports", "sports instant win"
    option :source, :required => true
    option :host, :required => true
    option :msg, :required => true
    option :gamename, :required => true
    option :debug
    def sports
      wb=EstormLottoGem::WbSports.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.sports_instantwin(options[:source],options[:msg],options[:gamename])
      res
    end
    
    desc "customer_list", "customer list for source"
    option :source, :required => true
    option :host, :required => true
    option :debug
    def customer_list
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.customer_list(options[:source])
      res
    end
    
    desc "get_session", "get_session for src"
    option :source, :required => true
    option :host, :required => true
    option :pin, :required => true
    option :debug
    def get_session
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.get_session(options[:source],options[:pin])
      res
    end
    
    desc "update_pin", "update pin on account"
    option :source, :required => true
    option :host, :required => true
    option :pin, :required => true
    option :newpin, :required => true
    option :debug
    def update_pin
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.update_pin(options[:source],options[:pin],options[:newpin])
      res
    end
    
    desc "release_cash", "release_cash from destination to src"
    option :source, :required => true
    option :host, :required => true
    option :from_account, :required => true
    option :pin, :required => true
    option :from_pin, :required => true
    option :value, :required => true
    option :debug
    def release_cash
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.release_cash(options[:source],options[:from_account],options[:value],options[:pin],options[:from_pin])
      res
    end
    
    desc "get_lotto4d_ticket", "get a 4d lottery ticket drawtype 4d or 3d"
    option :source, :required => true
    option :host, :required => true
    option :debug
    option :message, :required => false
    option :ticket_count, :required => false
    option :drawtype, :required => true
    def get_lotto4d_ticket
      wb=EstormLottoGem::WbLotto4d.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      ctick = 1
      ctick = options[:ticket_count] if !options[:ticket_count].nil? 
      res=wb.get_ticket(options[:source],options[:message],options[:drawtype],ctick)
      puts "result is #{res.inspect.to_s}"
      res
    end
    
    desc "promotion", "get promo ticket"
    option :source, :required => true
    option :host, :required => true
    option :debug
    option :message, :required => true
    option :ticket_count, :required => false
    def promotion
      wb=EstormLottoGem::WbLotto4d.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      ctick = 1
      ctick = options[:ticket_count] if !options[:ticket_count].nil? 
      res=wb.get_promotion(options[:source],options[:message],options[:drawtype],ctick)
      puts "result is #{res.inspect.to_s}"
      res
    end
    
    desc "client_received", "mark transaction as received"
    option :source, :required => true
    option :host, :required => true
    option :txid, :required => true
    option :debug
  
    def client_received
      debug=false
      debug=true if options[:debug]=='true'
      puts "txid is #{options[:txid]}"
      EstormLottoGem::ClientReceived.mark_received(options[:source],options[:txid],debug)
      puts "marking as printed"
      sleep 20  # wait for thread to finish
    end
    
    desc "get_draw_results", "get draw results for a draw"
    option :source, :required => true
    option :host, :required => true
    option :drawtype, :required => false
    option :debug
    def get_draw_results
      wb=EstormLottoGem::WbDrawResults.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.get_results(options[:source],options[:drawtype])
      puts "result is #{res.inspect.to_s}"
      res
    end
    
    desc "teds_simple_reporting", "get simple reporting"
    option :source, :required => true
    option :host, :required => true
    option :reporttype
    option :debug
    def teds_simple_reporting
      wb=EstormLottoGem::WbDrawResults.new
      reporttype='reporting'
      reporttype=options[:reporttype] if options[:reporttype]!=nil
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.teds_simple_reporting(options[:source],reporttype)
      puts res
      res
    end
    
    desc "sold_out", "get sold_out entries"
    option :source, :required => true
    option :host, :required => true
    option :drawtype,  :required => true
    option :debug
    def sold_out
      wb=EstormLottoGem::WbDrawResults.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.teds_sold_out(options[:source],options[:drawtype])
      puts res
      res
    end
    
    desc "check_payout", "check Payout for entry"
    option :source, :required => true
    option :host, :required => true
    option :drawtype, :required => true
    option :drawdate, :required => true
    option :md5, :required => true
    option :debug
    def check_payout
      wb=EstormLottoGem::WbCheckPayout.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.check_payout(options[:source],options[:md5],options[:drawdate],options[:drawtype])
      res
    end
    
    desc "process_payout", "check Payout for entry"
    option :source, :required => true
    option :host, :required => true
    option :drawtype, :required => true
    option :drawdate, :required => true
    option :md5, :required => true
    option :debug
    def process_payout
      wb=EstormLottoGem::WbCheckPayout.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.process_payout(options[:source],options[:md5],options[:drawdate],options[:drawtype])
      res
    end
  
    desc "retail", "retail transaction  use jwblack as sku"
    option :source, :required => true
    option :host, :required => true
    option :sku, :required => true
    option :retailprice
    option :custname
    option :debug
    def retail
      wb=EstormLottoGem::WbRetail.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.retail_sale(options[:source],options[:sku],options[:retailprice],options[:custname])
      puts res
      res
    end
    
    desc "pulsa", "pulsa telco load"
    option :source, :required => true
    option :host, :required => true
    option :value, :required => true
    option :telco, :required => true
    option :debug
    def pulsa
      wb=EstormLottoGem::WbTelcoLoad.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.telco_load(options[:source],options[:telco],options[:value])
      puts res
      res
    end
    
    desc "santa_payout", "santa payout testing"
    option :source, :required => true
    option :host, :required => true
    option :txid, :required => true
    option :gamename, :required => true
    option :debug
    def santa_payout
      wb=EstormLottoGem::WbTelcoLoad.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.santa_payout(options[:source],options[:txid],options[:gamename])
      puts res
      res
    end
    
    desc "send_sms", "sms notificaiton testing"
    option :source, :required => true
    option :destination, :required => true
    option :value, :required => true
    option :host, :required => true
    option :debug
    def send_sms
      postdata={}
      postdata[:destination]=options[:destination]
      postdata[:drawtype]='4d'
      postdata[:shortcode]='3032'
      postdata[:source]=options[:source]
      postdata[:message]='http_remote.recent_draws'
      postdata[:value]=options[:value]
      sm= EstormLottoGem::SmsNotification.new
      sm.set_host(options[:host])
      sm.set_debug if options[:debug]=='true'
      resp = sm.send_sms_msg(postdata)
      resp
    end
    
    desc "python_directory", "get python dir "  
    def python_directory
      wb=EstormLottoGem::Base.new
      res=wb.python_directory
      puts res
    end
    
    
    desc "process_invoice", "process invoice"
    option :source, :required => true
    option :host, :required => true
    option :value, :required => true
    option :invoice , :required => true
    option :debug
    def process_invoice
      wb=EstormLottoGem::WbRetail.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.process_invoice(options[:source],options[:value],options[:invoice])
      puts res
      res
    end
    
    
end

TestCli.start(ARGV)