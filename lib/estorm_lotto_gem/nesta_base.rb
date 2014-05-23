require 'sinatra/base'
require 'I18n'
module Nesta
  class NestaBase < Sinatra::Base
    def self.setup_configuration
      puts "Nesta base configure standalone"
      #flag=ENV['TEDWEB']=='true'
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
    configure do
      setup_configuration
     end
   
  end
end