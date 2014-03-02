#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
# needs upgrade to thor
# test_cli.rb get_balance --host=Scotts-MacBook-Pro.local:8080 --source=6590683565
class TestCli < Thor
    desc "get_balance", "get balance"
    option :source, :required => true
    option :host, :required => true
    def get_balance
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(options[:host])
      res=wb.get_balance(options[:source])
      res
    end
    desc "get_lotto4d_ticket", "get a 4d lottery ticket"
    option :source, :required => true
    option :host, :required => true
     option :message, :required => false
    def get_lotto4d_ticket
      wb=EstormLottoGem::WbLotto4d.new
      wb.set_host(options[:host])
      res=wb.get_ticket(options[:source],options[:message])
      res
    end
    
    
end

TestCli.start(ARGV)