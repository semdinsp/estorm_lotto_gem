require 'rubygems'
require 'hurley'
require 'json'
require 'estorm_lotto_tools'
require 'hwid'
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
    # @clnt=HTTPClient.new 
     @clnt=Hurley::Client.new 
     
     #@clnt.set_auth(nil, @account, @password)   
    end
    @clnt
  end
  def get_path
    "text_applications/handle_wallet_message.json"
  end
  def auth_email
    'api@estormtech.com'
  end
  def auth_token
    at='stxpgBdjcrWt9iAZUAyZ'
    at='EAc9S1JXBN5MXstisRC6' if @debug
    at
  end
  def get_transport
    transport='https'
    transport='http' if @debug
    transport
  end
   def action_url
     url="#{self.get_transport}://#{@host}/#{self.get_path}"
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
     @postdata[:hardware_id]=Hwid.systemid
    # @postdata[:auth_token]='EAc9S1JXBN5MXstisRC6'
     @postdata[:auth_token]=self.auth_token
     @postdata[:auth_email]=self.auth_email
     @postdata[:source]=src
     @postdata[:application]=appname
     @postdata.merge params
     #puts "postdata is #{@postdata}"
     @postdata
   end
   def merge_data_perform(msg,src,additional)
     self.build_postdata(msg, src)
     merge_perform(self.postdata,additional)
   end 
 def merge_perform(postdata,options)
   @postdata=postdata.merge(options)
   self.perform(self.action_url,@postdata)
 end
 def old_perform(url,postdata={})
     @uri=URI.parse(url)
    # puts "url is #{url}"
     res=''
     begin
       @clnt=self.build_client 
       Timeout::timeout(60) do    
         res=self.clnt.post_content(self.uri,JSON.generate(postdata),{'Content-Type' => 'application/json'}) 
         puts "URI #{self.uri}" if @debug
         res=JSON.generate([{'success'=>false,'error'=> "Error: application not installed: #{postdata[:application]}"}]) if res.include?('unknown app')
       end
           res=JSON.generate([{'success'=>false,'error'=> "Error: #{e.message} #{e.inspect}"}])
          # SHOULD SEND EMAIL HERE
          puts "BAD RESPONSE #{e.inspect}"
     end
         JSON.parse(res)
  end
  def perform(url,postdata={})
      @uri=URI.parse(url)
     # puts "url is #{url}"
       res=JSON.generate([{'success'=>false,'error'=> "created before processing by Hurely [#{Time.now}] "}])
      
      begin
        timeout=45
        @clnt=self.build_client 
        @clnt.header[:accept] = "application/json"
        @clnt.header[:content_type] = "application/json"
        @clnt.request_options.timeout = timeout   # set to 60
        response= @clnt.post(@uri)  do |req|
            req.body=JSON.generate(postdata)
            req.options.timeout = timeout
            #  puts "request is #{req}"
           end
         if response.success?
           res=response.body    
           res=JSON.generate([{'success'=>false,'error'=> "Error: application not installed: #{postdata[:application]}"}]) if response.body.include?('unknown app')
         else
           res=JSON.generate([{'success'=>false,'error'=> "Server response [#{Time.now}] body #{response.body.to_s}"}]) if !response.body.nil?
         end
         
       rescue Exception => e
         emsg="Exception Error: #{e.message} #{e.inspect} [#{Time.now}]"
         puts emsg
         res=JSON.generate([{'success'=>false,'error'=> emsg }])
       end
          JSON.parse(res)
   end
   def print_msg(msg, printer_type='adafruit')
     puts "msg: #{msg} printer #{printer_type}"
     system("/usr/bin/python","#{self.python_directory}/print_msg.py",msg,printer_type) if printer_type!= "none"
      # system("/usr/bin/python","/home/pi/Python-Thermal-Printer/print_msg.py",msg,printer_type)  if printer_type!= "none"
   end
   
   def print_transaction(res,seller,txtype,printer_type='adafruit',txid="txidFail")
      respstring=res
      puts  "print results #{res} class #{res.class}"
      txid="txidfail" if txid==nil
      system("/usr/bin/python","#{self.python_directory}/print_transaction.py",respstring,seller,txtype,printer_type,res['success'],txid) if printer_type!= "none"
      [respstring]
   end
   
   # THIS FOR COMPATABILITY DELETE AFTER FEW MONTS
   def self.sw_modules
    EstormLottoGem::Constants.modules
  end
 def self.product_types
      EstormLottoGem::Constants.product_types 
  end
  def self.printer_types
    EstormLottoGem::Constants.printer_types
 end
 


   end    # Class
end    #Module