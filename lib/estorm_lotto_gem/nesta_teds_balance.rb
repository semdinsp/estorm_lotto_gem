#require 'nesta_base'
require 'sinatra/support/numeric'
module Nesta
  class NestaTedsBalance < Nesta::NestaCoreBase
    register Sinatra::Numeric
    post '/getbalance' do
      wb=awb_balance_setup
      session[:balance]=0
      #wb.set_debug
      res=wb.get_balance(settings.estorm_src)
      atype=:error
      msg=""
      manage_success_message(res)  {  atype=:notice
         msg="Balance is: #{res.first['balance']} as of: [#{Time.now}]"
         session[:balance]=currency(res.first['balance'])
           }
       manage_error_message(res) {
         msg="Could not get balance #{res.inspect.to_s}"
         session[:balance]='Connection issue'  }
        teds_flash_and_redirect(msg,atype,'/balance')
    end
  end
end #module