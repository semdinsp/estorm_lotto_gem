module Nesta
  class NestaWalletRoutes < Nesta::NestaBase
    def awb_balance_setup
      wb=EstormLottoGem::WbBalance.new
      wb.set_host(settings.estorm_host)
      # wb.set_debug
       wb
    end
post "/changepin" do
  puts "change pin params: #{params} settings #{settings.estorm_printer}"
  wb=EstormLottoGem::WbBalance.new
  #wb.set_debug
  wb.set_host(settings.estorm_host)
  #wb.set_host("localhost:8080")
  errmsg=""
  errmsg="new pin and new pin2 not same" if params['newpin']!=params['newpin2']
  errmsg="pin must be at least 6 digits" if params['newpin'].size <6
  
  if errmsg!=""
     teds_flash_and_redirect(errmsg,:error,"/balance")
   else
     res=wb.update_pin(settings.estorm_src,params['pin'],params['newpin'])
     manage_success_message(res)   {
        teds_flash_and_redirect("pin changed",:notice,"/balance")   }
      manage_error_message(res)   {
         teds_flash_and_redirect("pin unchanged #{res.inspect.to_s}",:error,"/balance")   }
   end
 end
   post "/wbrelease_cash" do
     puts "params: #{params}"
     wb=awb_balance_setup    
     res=wb.release_cash(settings.estorm_src,params['from_account'],params['amount'],params['pin'],params['from_pin'])
     manage_success_message(res)   {  #res,seller,txtype,printer_type='adafruit')
        respstring=""
        ["","Copy"].each { |v|
            respstring = wb.print_transaction(res.first.to_s,settings.estorm_src,"Release Cash #{v}",settings.estorm_printer)
               }
        teds_flash_and_redirect(respstring,:notice,"/balance")   }
      manage_error_message(res)   {
       system("/usr/bin/python","#{wb.python_directory}/print_msg.py",res.inspect.to_s,settings.estorm_printer) 
       teds_flash_and_redirect(res.inspect.to_s,:error,"/balance")
     }
     #redirect to('/balance')
   end
   post "/wbtransfer" do
     puts "params: #{params}"
     wb=awb_balance_setup
     res=wb.transfer(settings.estorm_src,params['destination'],params['amount'],params['pin'])
     manage_success_message(res)   {  #res,seller,txtype,printer_type='adafruit')
       respstring=""
       ["","Copy"].each { |v|
           respstring = wb.print_transaction(res.first.to_s,settings.estorm_src,"Transfer #{v}",settings.estorm_printer)
              }
        teds_flash_and_redirect(respstring,:notice,"/balance")   }
      manage_error_message(res)   {
       system("/usr/bin/python","#{wb.python_directory}/print_msg.py",res.inspect.to_s,settings.estorm_printer) 
       teds_flash_and_redirect(res.inspect.to_s,:error,"/balance")
     }
     #redirect to('/balance')
   end
 end  #class
end #module