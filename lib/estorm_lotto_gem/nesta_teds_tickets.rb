module Nesta
  class NestaTedsTickets < Nesta::NestaCoreBase    # ticket stuff
    def teds_parse_message(msg)
      atype=:notice
      atype=:error if msg['paid']==true
      amsg="Winning Ticket: #{msg['value']}, details: #{msg}"
      amsg="ALREADY PAID #{amsg}" if atype==:error
      return [amsg,atype]
    end
  
    post '/validation' do
      puts "Validation params: #{params} settings #{settings.estorm_printer}"
      wb=EstormLottoGem::WbCheckPayout.new
      # wb.set_debug
      wb.set_host(settings.estorm_host)
      res=wb.check_payout(settings.estorm_src,params['md5'],params['drawdate'],params['drawtype'])
       manage_success_message(res)   {
        respstring = wb.print_payout(res,settings.estorm_src,params['drawtype'],params['drawdate'],params['md5'],settings.estorm_printer)
          msg,atype=teds_parse_message(res.first['payout'])
          teds_flash_and_redirect(msg,atype,"/redeem")   }
        manage_error_message(res)   {
         system("/usr/bin/python","#{wb.python_directory}/print_no_payout.py",res.inspect.to_s,settings.estorm_src,params['drawtype'],params['drawdate'],params['md5'],settings.estorm_printer) 
         teds_flash_and_redirect(res.inspect.to_s,:error,"/redeem")
       }
     
      #redirect to("/redeem")
    end
    post '/ticket' do
      puts "POST TICKETS params: #{params} settings #{settings.estorm_printer}"
      if params['values']!=nil and params['values'].size >=4
        tval=params['values']
        params['digit1']=tval[0]  
        params['digit2']=tval[1]
        params['digit3']=tval[2]
        params['digit4']=tval[3]
        params['ticket_type']='3d' if tval[0]=='X'
        params['ticket_type']='2d' if tval[1]=='X' and params['ticket_type']=='3d'
        puts "updated params now #{params}"
      end
      params['ticket_type']='3d' if params['digit1']=='X'
      params['ticket_type']='2d' if params['digit2']=='X' and params['ticket_type']=='3d'
      params['digit1']="" if ['2d','3d'].include?(params['ticket_type'])
      params['digit2']="" if ['2d'].include?(params['ticket_type'])
      imsg="#{params['ticket_type']} #{params['digit1']} #{params['digit2']} #{params['digit3']} #{params['digit4']}"
      puts "msg #{imsg}"
      wb=EstormLottoGem::WbLotto4d.new
      wb.set_host(settings.estorm_host)
      #wb.set_debug
      res=wb.get_ticket(settings.estorm_src,imsg,params['ticket_type']) 
      msgtype=:notice
      msg=""
      manage_success_message(res)  {  digits,drawdate,src,code,msgs,txid = wb.print_ticket(res.first,settings.estorm_src,params['ticket_type'],settings.estorm_printer) 
          msg="digits #{digits} dd #{drawdate} src #{src} code #{code} msgs #{msgs} type: #{params['ticket_type']}"
          flash[:notice]=msg         
      }
      manage_error_message(res)   {
         msg=res.inspect.to_s
         msgtype=:error
         print_error(res)  }
         
        teds_flash_and_redirect(msg,msgtype,"/tickets")
        
    end
    post '/redemption' do
      puts "Redemption params: #{params} settings #{settings.estorm_printer}"
      wb=EstormLottoGem::WbCheckPayout.new
      # wb.set_debug
      wb.set_host(settings.estorm_host)
      res=wb.process_payout(settings.estorm_src,params['md5'],params['drawdate'],params['drawtype'])
      manage_success_message(res)   {
             respstring = wb.print_paid_ticket(res,settings.estorm_src,params['drawtype'],params['drawdate'],params['md5'],settings.estorm_printer)
             msg="#{respstring}"
             #msg=res.first['payout']
             teds_flash_and_redirect(msg,:notice,"/redeem")  }
          manage_error_message(res)   {
            msg=res.inspect.to_s
            system("/usr/bin/python","#{wb.python_directory}/print_no_payout.py",res.inspect.to_s,settings.estorm_src,params['drawtype'],params['drawdate'],params['md5'],settings.estorm_printer) 
            teds_flash_and_redirect(msg,:error,"/redeem")  }
       end
  end
end
