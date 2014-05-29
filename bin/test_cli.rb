#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
require 'I18n'
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
    option :drawtype, :required => true
    def get_lotto4d_ticket
      wb=EstormLottoGem::WbLotto4d.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.get_ticket(options[:source],options[:message],options[:drawtype])
      res
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
      res
    end
    desc "teds_simple_reporting", "get simple reporting"
    option :source, :required => true
    option :host, :required => true
    option :debug
    def teds_simple_reporting
      wb=EstormLottoGem::WbDrawResults.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      res=wb.teds_simple_reporting(options[:source])
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
    
    
end

TestCli.start(ARGV)