puts File.dirname(__FILE__)
require 'estorm_lotto_gem'
require File.dirname(__FILE__) + '/test_helper.rb' 


class EstormLottoGemTest <  Minitest::Test

  def setup
    @f=EstormLottoGem::Base.new
    @btn-EstormLotoGem::Button.new
  end
  
  def test_basic
    assert @f.debug, "should be true"
  end
  def test_client
     @f.build_client
     assert @f.clnt!=nil, "should be not nil"
     @f.set_host('testing util')
     assert @f.action_url.include?('testing util'), "action url shuld be included #{@f.action_url}"
   end
   def test_button
     assert @btn!=nil, "should not be nil"
     assert @btn.test, "should return true"
     
   end
  
  

end
