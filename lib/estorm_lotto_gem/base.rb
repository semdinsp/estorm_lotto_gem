require 'rubygems'
require 'httpclient'
module EstormLottoGem
  class Base
   # attr_accessor :randgen, :myrange
  def debug
    true
  end
  attr_accessor :clnt, :account, :password, :extheader, :uri, :host
    @host= 'localhost:8080'
   # @@host= 'estorm-lotto4d.herokuapp.com' if ['production','staging'].include?(Rails.env)
  def set_debug
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
     url="http://#{@host}/api_lotto/create.json"
     url
   end
  def perform(url,postdata={})
      @uri=URI.parse(url)
      puts "url is #{url}"
      res=''
      begin
        @clnt=self.build_client 
        Timeout::timeout(40) do    
          res=self.clnt.post_content(self.uri, postdata,{'Content-Type' => 'application/json'}) 
        end
      rescue Errno::ECONNREFUSED,Timeout::Error,HTTPClient::BadResponseError => e
           res='application error response or timeout'
           # SHOULD SEND EMAIL HERE
           puts "BAD RESPONSE #{e.inspect}"
      end
          res
   end
  

   end    # Class
end    #Module