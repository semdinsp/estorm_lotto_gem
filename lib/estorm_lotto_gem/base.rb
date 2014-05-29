require 'rubygems'
require 'httpclient'
require 'multi_json'
require 'estorm_lotto_tools'
module EstormLottoGem
  class Base
   # attr_accessor :randgen, :myrange
  def debug
    @debug
  end
  attr_accessor :clnt, :account, :password, :extheader, :uri, :host, :postdata,:debug
  def initialize
     @host= 'estorm-sms.herokuapp.com'
     @debug=false
  end
  def file_info
    puts " directory #{File.dirname(__FILE__)}"
    puts " filename #{__FILE__}"
  end
  def gem_file_directory
    "#{File.dirname(__FILE__)}"
  end
  def python_directory
      "#{File.dirname(__FILE__)}/python"
  end
   # @@host= 'estorm-lotto4d.herokuapp.com' if ['production','staging'].include?(Rails.env)
  def set_debug
    set_host('localhost:8080')
    @debug=true
    # @@host= 'localhost:8083'
  end
  def set_host(ht)
    @host= ht
  end
  def set_credentials(account,passwd)
      @account=account
      @password=passwd    
  end
  def build_client
    if @clnt==nil then
     @clnt=HTTPClient.new 
     #@clnt.set_auth(nil, @account, @password)   
    end
    @clnt
  end
   def action_url
     url="https://#{@host}/text_applications/handle_wallet_message.json"
     url="http://#{@host}/text_applications/handle_wallet_message.json" if @debug
     url
   end
   @@config=nil
   def get_config
     if @@config==nil then
       @@config =  EstormLottoTools::BasicConfig.new(nil,nil) if ENV['TRAVIS']!='true' 
       puts "SCOTT environment #{ENV['TRAVIS']} file: #{File.dirname(__FILE__)}"
       @@config = EstormLottoTools::BasicConfig.new(File.dirname(__FILE__),'../../test/test.conf') if ENV['TRAVIS']=='true'    #TESTING
     end
     @@config.params
   end
   def build_postdata(appname, src,params={})
     @postdata={}
     @postdata[:security_code]='12345'
     @postdata[:timestamp]=Time.now.to_s
    # @postdata[:auth_token]='EAc9S1JXBN5MXstisRC6'
     @postdata[:auth_token]='stxpgBdjcrWt9iAZUAyZ'
     @postdata[:auth_token]='EAc9S1JXBN5MXstisRC6' if @debug
     @postdata[:source]=src
     @postdata[:application]=appname
     @postdata.merge params
     #puts "postdata is #{@postdata}"
     @postdata
   end
  def self.printer_types
    [['epson','epson'],['epson2','epson2'],['none','none'],['adafruit','adafruit'],['epsont81','epsont81']]
 end
  def perform(url,postdata={})
      @uri=URI.parse(url)
     # puts "url is #{url}"
      res=''
      begin
        @clnt=self.build_client 
        Timeout::timeout(60) do    
          res=self.clnt.post_content(self.uri,MultiJson.dump(postdata),{'Content-Type' => 'application/json'}) 
          res=MultiJson.dump([{'success'=>false,'error'=> "Error: application not installed: #{postdata[:application]}"}]) if res.include?('unknown app')
        end
      rescue Errno::ECONNREFUSED,Timeout::Error,HTTPClient::BadResponseError,Exception => e
           res=MultiJson.dump([{'success'=>false,'error'=> "Error: #{e.message} #{e.inspect}"}])
           # SHOULD SEND EMAIL HERE
           puts "BAD RESPONSE #{e.inspect}"
      end
          MultiJson.load(res)
   end
   def print_msg(msg, printer_type='adafruit')
     system("/usr/bin/python","#{self.python_directory}/print_msg.py",msg,printer_type) if printer_type!= "none"
      # system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_msg.py",msg,printer_type)  if printer_type!= "none"
   end
   
   def print_transaction(res,seller,txtype,printer_type='adafruit')
      respstring=res
      puts  "rpint results #{res} class #{res.class}"
      system("/usr/bin/python","#{self.python_directory}/print_transaction.py",respstring,seller,txtype,printer_type,res['success']) if printer_type!= "none"
      [respstring]
   end

   end    # Class
end    #Module