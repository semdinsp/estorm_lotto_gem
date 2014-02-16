Gem::Specification.new do |s|
  s.name        = "randprize"
  s.version     = "0.1.4"
  s.author      = "Scott Sproule"
  s.email       = "scott.sproule@ficonab.com"
  s.homepage    = "http://github.com/semdinsp/randprize"
  s.summary     = "Random prize from hash with odds values"
  s.description = "Select a random prize from a list with odds" 
  s.executables = ['']    #should be "name.rb"
  s.files        = Dir["{lib,test}/**/*"] +Dir["bin/*.rb"] + Dir["[A-Z]*"] # + ["init.rb"]
  s.require_path = "lib"
  s.license = 'MIT'
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
