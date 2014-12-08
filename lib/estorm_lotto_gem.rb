lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Dir[File.join(File.dirname(__FILE__), 'estorm_lotto_gem/**/*.rb')].sort.each { |lib| require lib }