require 'rubygems'
require 'httpclient'
require 'multi_json'

module EstormLottoGem
  class Base
   # attr_accessor :randgen, :myrange
  def debug
    true
  end
  attr_accessor :clnt, :account, :password, :extheader, :uri, :host, :postdata
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
     url="http://#{@host}/text_applications/handle_wallet_message.json"
     url
   end
   def build_postdata(appname, src,params={})
     @postdata={}
     @postdata[:security_code]='12345'
     @postdata[:auth_token]='EAc9S1JXBN5MXstisRC6'
     @postdata[:source]=src
     @postdata[:application]=appname
     @postdata.merge params
     puts "postdata is #{@postdata}"
     @postdata
   end
  def perform(url,postdata={})
      @uri=URI.parse(url)
      puts "url is #{url}"
      res=''
      begin
        @clnt=self.build_client 
        Timeout::timeout(40) do    
          res=self.clnt.post_content(self.uri,MultiJson.dump(postdata),{'Content-Type' => 'application/json'}) 
        end
      rescue Errno::ECONNREFUSED,Timeout::Error,HTTPClient::BadResponseError => e, Exception => e
           res=MultiJson.dump({'success'=>false,'error'=> "Error: #{e.message} #{e.inspect}"})
           # SHOULD SEND EMAIL HERE
           puts "BAD RESPONSE #{e.inspect}"
      end
          MultiJson.load(res)
   end
  

   end    # Class
end    #Module