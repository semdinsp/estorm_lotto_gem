#!/usr/bin/env ruby
require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
require 'I18n'
# needs upgrade to thor
# test_cli.rb get_balance --host=Scotts-MacBook-Pro.local:8080 --source=6590683565
class TestLoad < Thor
    
    
    desc "sports", "sports instant win"
    option :source, :required => true
     option :count, :required => true
    option :host, :required => true
    option :debug
    def sports
      wb=EstormLottoGem::WbSports.new
      wb.set_host(options[:host])
      wb.set_debug if options[:debug]=='true'
      total=0
      1.upto(options["count"].to_i)  {
         res=wb.sports_instantwin(options[:source]) 
          total=total+res.first['prize']  }
          puts "Count #{options[:count]} total payout #{total}"
     end
  end

  TestLoad.start(ARGV)