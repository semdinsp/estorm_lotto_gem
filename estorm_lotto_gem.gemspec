Gem::Specification.new do |s|
  s.name        = "estorm_lotto_gem"
  s.version     = "1.3.9"
  s.author      = "Scott Sproule"
  s.email       = "scott.sproule@ficonab.com"
  s.homepage    = "http://github.com/semdinsp/estorm_lotto_gem"
  s.summary     = "Estorm lottery tools"
  s.description = "Tools for raspberry pi and other remote access" 
  s.executables = ['button_controller.rb','button_basic.rb','test_load.rb','test_cli.rb']    #should be "name.rb"
  s.files        = Dir["{lib,test}/**/*"] +Dir["bin/*.rb"] + Dir["[A-Z]*"] # + ["init.rb"]
  s.require_path = "lib"
  s.license = 'MIT'
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  s.add_runtime_dependency 'httpclient', '>= 2.3'
  s.add_runtime_dependency 'pi_piper' if !(/darwin/ =~ RUBY_PLATFORM) != nil
  s.add_runtime_dependency 'thor', '>= 0.19'
  s.add_runtime_dependency 'multi_json', '>= 1.9'
  s.add_runtime_dependency 'estorm_lotto_tools'
  
end
