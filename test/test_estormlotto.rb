puts File.dirname(__FILE__)
#require 'estorm_lotto_gem'
require File.dirname(__FILE__) + '/test_helper.rb' 


class EstormLottoGemTest <  Minitest::Test

  def setup
    @f=  EstormLottoGem::Base.new
  end
  
  def test_basic
    assert !@f.debug, "should be false"
  end
  def test_creation
    assert EstormLottoGem::Base.new!=nil, "should be created"
    assert EstormLottoGem::Constants.new!=nil, " constants should be created"
    assert EstormLottoGem::TelcoLoad.new!=nil,  " telco laod should be created"
    assert EstormLottoGem::WbBalance.new!=nil, "wb balance should be created"
    assert EstormLottoGem::WbCheckPayout.new!=nil, " wb check payoutshould be created"
    assert EstormLottoGem::WbLotto4d.new!=nil, "wb lotto should be created"
    assert EstormLottoGem::WbRetail.new!=nil, "retailshould be created"
    assert EstormLottoGem::WbSports.new!=nil, "wb sports should be created"
    assert EstormLottoGem::ZLoadPin.new!=nil, "z load pin  should be created"
    assert EstormLottoGem::LogInstantwin.new!=nil, "log instant win should be created"
    
  end
  def test_printers
    assert EstormLottoGem::Constants.printer_types.inspect.to_s.include?('epsont82'), "should include epson t82"
  end
  def test_printers
    assert EstormLottoGem::Constants.sub_agent_list.inspect.to_s.include?('a'), "should include a"
  end
  def test_printers2
    assert EstormLottoGem::Base.printer_types.inspect.to_s.include?('epsont82'), "should include epson t82"
  end
  def test_modules
    assert EstormLottoGem::Constants.sw_modules.inspect.to_s.include?('4d'), "should include  4d"
  end
  def test_telcos
    assert EstormLottoGem::Constants.telcos.inspect.to_s.include?('tt'), "should include tt"
  end
  def test_status
    assert EstormLottoGem::Constants.customer_status.inspect.to_s.include?('gold'), "should include gold"
  end
  def test_debug
     @f.build_client
     assert @f.clnt!=nil, "should be not nil"
     assert @f.action_url.include?('estorm-sms'), "action url shuld be included #{@f.action_url}"
     @f.set_debug
     assert @f.action_url.include?('localhost'), "action url shuld be included #{@f.action_url}"
      assert @f.debug, "should be true"
   end
   def test_urls
        @f.build_client
        assert @f.auth_token=='stxpgBdjcrWt9iAZUAyZ', "should be correct"

        assert @f.action_url.include?('estorm-sms'), "action url shuld be included #{@f.action_url}"
        assert @f.action_url.include?('https'), "action url shuld be https #{@f.action_url}"
        
        @f.set_debug
                assert @f.auth_token=='EAc9S1JXBN5MXstisRC6', "should be correct"
        assert @f.action_url.include?('localhost'), "action url shuld be included #{@f.action_url}"
        assert @f.action_url.include?('http'), "action url shuld be http #{@f.action_url}"
        
        assert @f.debug, "should be true"
   end
  def test_client
     @f.build_client
     assert @f.clnt!=nil, "should be not nil"
     @f.set_host('testing util')
     assert @f.action_url.include?('testing util'), "action url shuld be included #{@f.action_url}"
   end

  
    def test_cfg
      assert @f!=nil, "should not be nil"
      params=@f.get_config
      puts "cnfig file #{params}"
      assert params !=nil, "should have params "

    end
  
  

end
