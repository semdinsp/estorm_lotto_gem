module Nesta
    module SessionHelper extend self
      module Helpers
      def current_user
        puts "session is #{session.inspect}"
        # THIS IS A HACK
        User.get(session['warden.user.default.key'])
      end
      end
      def registered(app)
             app.helpers Helpers
      end
    end
  class NestaCoreBase <  NestaBase
   register  Nesta::SessionHelper
def get_draw_results(params)
  wb=EstormLottoGem::WbDrawResults.new
  # wb.set_debug
  wb.set_host(settings.estorm_host)
  res=wb.get_results(current_user.estorm_src,params['ticket_type']) 
  [res,wb]
end
def print_error(res,dest="/")
  wb=EstormLottoGem::Base.new
  puts "In print error"
  wb.print_msg(res.inspect.to_s,settings.estorm_printer)
  teds_flash_and_redirect(res.inspect.to_s,:error,dest)
end
def manage_success_message(res)
      yield if res!=nil and res.first!=nil and res.first['success']       
end
def manage_error_message(res)
      yield if res!=nil and res.first!=nil and !res.first['success']       
end
def teds_flash_and_redirect(msg,atype=:notice,dest="/")
  flash[atype]=msg
  #sleep 0.5
  redirect to(dest)
end
def awb_balance_setup
  wb=EstormLottoGem::WbBalance.new
  wb.set_host(settings.estorm_host)
  # wb.set_debug
   wb
end

end #class

end #module