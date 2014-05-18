module Nesta
  class NestaTedsWinners < Nesta::NestaBase    #winners and ramalan
    
    post '/printramalan' do
      puts "Print Ramalan params: #{params} settings #{settings.estorm_printer}"
      res,wb=get_draw_results(params)
      manage_success_message(res)   {  respstring = wb.print_ramalan(res.first,settings.estorm_src,params['ticket_type'],settings.estorm_printer) 
                                        msg="#{respstring}"
                                        teds_flash_and_redirect(msg,:notice,"/tickets") }
      manage_error_message(res) { print_error(res,"/tickets") }
    end
   
    post '/printwinners' do
      puts "Print Winners params: #{params} settings #{settings.estorm_printer}"
      res,wb=get_draw_results(params)
     
      manage_success_message(res)   {  respstring = wb.print_results(res.first,settings.estorm_src,params['ticket_type'],settings.estorm_printer) 
                                        msg="#{respstring}"
                                        teds_flash_and_redirect(msg,:notice,"/tickets") }
      manage_error_message(res) { print_error(res,"/tickets") }
    end
  end # clase
end #mdoule