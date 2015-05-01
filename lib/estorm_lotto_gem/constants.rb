module EstormLottoGem
  class Constants
    def self.sw_modules
      [['4d','4d'],['3d','3d'],['2d','2d'],['sport','sport'],
      ['combo','combo'],['product','product']]
   end
  def self.product_types
    [['jwblack_750ml','jwblack_750ml'],['jwblack_200ml','jwblack_200ml'],['jwblack_375ml','jwblack_375ml'],['jwblack_1l','jwblack_1l'],
       ['prolink','prolink'],['special Z','special Z']]
   end
   def self.printer_types
     [['epson','epson'],['epson2','epson2'],['none','none'],['adafruit','adafruit'],
     ['epsont81','epsont81'],['kiosk','kiosk'],['epsont82','epsont82']]
  end
  def self.telcos
    [['scott','scott'],['telkomcel','telkomcel'],['bwdi','bwdi']]
  end
  def self.pulsa_values
    [['1','1'],['2','2'],['5','5'],['10','10'],['25','25']]
  end
  
  def self.upgrade_types
    [['gems','gems'],['system','system']]
  end
  
  def self.report_types
    [['reporting','reporting'],['detail','detail'],['margin','margin']]
  end
  
  def self.sub_agent_list
    ['a','b','c','d','e']
  end
    
  end
end
