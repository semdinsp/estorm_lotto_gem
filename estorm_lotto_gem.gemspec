Gem::Specification.new do |s|
  s.name        = "estorm_lotto_gem"
  s.version     = "3.1.82"
  s.author      = "Scott Sproule"
  s.email       = "scott.sproule@ficonab.com"
  s.homepage    = "http://github.com/semdinsp/estorm_lotto_gem"
  s.summary     = "Estorm lottery tools"
  s.description = "Tools for raspberry pi and other remote access" 
  #s.executables = ['button_controller.rb','test_load.rb','test_cli.rb','test_log_instantwin.rb']    #should be "name.rb"
  s.files        = Dir["{lib,test}/**/*"] +Dir["bin/*.rb"] + Dir["[A-Z]*"] # + ["init.rb"]
  s.license = 'MIT'
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
  s.add_runtime_dependency 'httpclient', '~> 2'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'hwid','~> 0.1'
  s.add_runtime_dependency 'mqtt','~> 0.1'
  #s.add_runtime_dependency 'bcrypt'
  s.add_runtime_dependency 'hurley', '~> 0.1'
  s.add_runtime_dependency 'estorm_lotto_tools', '~> 0.3'
  signing_key = File.expand_path('~/.ssh/gem-private_key.pem')

    if File.exist?(signing_key)
      s.signing_key = signing_key
      s.cert_chain  = ['gem-public_cert.pem']
    end

    #gem.files         = `git ls-files`.split($/)
    s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
   # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
    s.require_paths = ["lib"]
end
