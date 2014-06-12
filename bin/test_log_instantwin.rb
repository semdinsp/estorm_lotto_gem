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
  end

  TestLog.start(ARGV)