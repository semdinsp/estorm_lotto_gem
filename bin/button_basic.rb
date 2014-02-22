#!/usr/bin/env ruby
puts "starting....."
puts "to update run: sudo gem install estorm_lotto_gem  --source https://n6ojjVsAxpecp7UjaAzD@gem.fury.io/semdinsp/"
require 'estorm_lotto_gem'
mgr=EstormLottoGem::Button.new
mgr.manage_buttons
