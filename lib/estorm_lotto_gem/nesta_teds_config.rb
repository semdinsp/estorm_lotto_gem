module Nesta
  class NestaTedsConfig < Nesta::NestaCoreBase
    post '/update_printer' do
      puts "update printer params #{params}"
      @basic = build_config
      @basic.update_printer(params['newprinter'])
      teds_flash_and_redirect("Please restart system for updated [#{params['newprinter']}] from: [#{settings.estorm_printer}]",:notice,"/others")
    end
    post '/update_system' do
      puts "update system params #{params}"
      teds_flash_and_redirect("Please wait 30 minutes and reboot",:notice,"/others")
    end
    post "/shutdown" do
      puts "params: #{params}"
      cmd=EstormLottoTools::WebUtilities.web_app_shutdown(params)
      teds_flash_and_redirect(cmd,:error)
    end
    post "/connect" do
      puts "params: #{params}"
      session[:desturl]=params['prolink']
      teds_flash_and_redirect(@desturl.to_s,:notice,'/modem')
    end
    post '/launch_tools' do
      puts "lanch toosl #{params}"
      tool= params['tool_name']
      system("xhost +localhost:root")
      system("DISPLAY=:0 #{tool} &") if ['wpa_gui','ifup wlan0'].include?(tool)
      teds_flash_and_redirect("#{tool} should start soon",:notice,"/others")
    end
  end
end