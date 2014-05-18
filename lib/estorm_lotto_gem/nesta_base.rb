require 'sinatra/base'
module Nesta
  class NestaBase < Sinatra::Base
    configure do
      @basic = EstormLottoTools::BasicConfig.new(File.dirname(__FILE__),'test.conf') if settings.environment==:test
      @basic = EstormLottoTools::BasicConfig.new(nil,nil) if settings.environment!=:test
       set :estorm_src, @basic.identity
       set :estorm_host, @basic.host
       set :estorm_printer, @basic.printer
       set :estorm_debug, false
       set :estorm_debug, true if @basic.identity=='6590683565'
       puts "src/identity: #{settings.estorm_src} host: #{settings.estorm_host} printer: #{settings.estorm_printer}"
       I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
       I18n.load_path=Dir[File.join(settings.root, 'config/locales', '*.yml')]
       I18n.backend.load_translations
       I18n.locale = 'en'
     end
     def get_draw_results(params)
       wb=EstormLottoGem::WbDrawResults.new
       # wb.set_debug
       wb.set_host(settings.estorm_host)
       res=wb.get_results(settings.estorm_src,params['ticket_type']) 
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
  end
end