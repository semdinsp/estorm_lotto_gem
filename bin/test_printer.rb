require 'rubygems'
require 'thor'
require 'estorm_lotto_gem'
require 'json'


class PrinterTest < Thor
  
  desc "exitcode", "test exit code "  
  option :exitcode  
  def exitcode
    exitcode=0
    exitcode=options[:exitcode] if !options[:exitcode].nil?
    basegem=EstormLottoGem::Base.new
    puts "excit code is: #{exitcode}"
    res=system("/usr/bin/python","#{basegem.python_directory}/test_exit.py", exitcode.to_s) 
    puts "res is #{res.inspect}"  
  end
  
  desc "testprinter", "test printer code "  
  option :testprinter  
  option :printer, required: true
  def testprinter
    exitcode=0
    exitcode=options[:exitcode] if !options[:exitcode].nil?
    basegem=EstormLottoGem::Base.new
    jsonmsg={newprinter: options[:printer],success: true, hwid: Hwid.systemid,
             hostname: Socket.gethostname, ip: 'test'}
    res=EstormLottoGem::MqttclientTms.tms_print_generic(jsonmsg.to_json.to_s, Hwid.systemid,"Printer Test",'timorscratch',options[:printer])
     
 
    puts "res is #{res.inspect}"  
  end
  
end

PrinterTest.start(ARGV)