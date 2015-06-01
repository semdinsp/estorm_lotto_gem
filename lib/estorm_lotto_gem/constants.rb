module EstormLottoGem
  class Constants
    def self.sw_modules
      build_array(['4d','3d','2d','sport','combo','product','combo10'])
      
   end
  def self.product_types
    [['jwblack_750ml','jwblack_750ml'],['jwblack_200ml','jwblack_200ml'],['jwblack_375ml','jwblack_375ml'],['jwblack_1l','jwblack_1l'],
       ['prolink','prolink'],['special Z','special Z']]
   end
   def self.build_array(list)
     res=[]
     list.each {|li| res << [li,li]}
     res
   end
   def self.printer_types
     build_array(['espon','epson2','none','adafruit','epsont81','kiosk','epsont82'])
     
  end
  def self.telcos
    build_array(['telcomcel','scott','bwdi'])
    
  end
  def self.pulsa_values
      build_array(['1','2','5','10','25'])
  end
  def self.game_types
    build_array(['4d','3d','2d','combo','combo10'])
  end
  
  def self.upgrade_types
    build_array(['gems','system'])
  end

  def self.customer_status
     [['none','none'],['bronze','bronze'],['gold','gold'],['platinum','platinum'],['diamond','diamond']]
  end
  
  def self.district_manager_teams
    build_array(['unassigned','None','Ricky','Mili','Belo'])
  end
  
  def self.report_types
    [['reporting','Simple'],['detail','Detail'],['margin','margin'],['pulsa','pulsa']]
  end
  
  def self.sub_agent_list
    ['a','b','c','d','e']
  end
    
  end
end
