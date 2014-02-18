puts File.dirname(__FILE__)
require File.dirname(__FILE__) + '/test_helper.rb' 


class EstormLottoGemTest <  Minitest::Test

  def setup
    @f=EstormLottoGem::Base.new
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
  
  

end
