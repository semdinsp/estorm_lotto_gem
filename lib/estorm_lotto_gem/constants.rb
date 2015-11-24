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
   def self.pinload_messages
     build_array(['Haruka sms ELEC*no kontador*PIN ba 73631234','Send *122*PIN# to load your credit','Marka/Enter 100+PIN press/liga send'])  
  end
  def self.text_applications
    build_array(['Textecho::Base','Textecho::Multimessage','WalletMiscellaneous','Textecho::Randgen','Textecho::Timecheck','Lotto4d',
      'InstantWin','SmsCommands','WalletGetSession','WalletBalance','WalletReleaseCash','WalletDrawResults',
       'WalletProcessPayout','WalletUpdatePin','TedsSimpleReporting','WalletLotto4d','Lotto3d','WalletCheckPayout',
       'WalletReload',  'WalletTransfer','WalletInstantLocal','SmsProperties',
      'WalletLotto3d','WalletTelcoTransfer','WalletLotto2d','Cockfighting','SantaSms','SantaWallet','LearningChannel',
       'Bible','Donation','WalletCashout','WalletSoldOut','WalletSantaPayout',  'WalletLottocombo','WalletRetailProduct','WalletTelcoLoad'])
  end
   def self.printer_types
     build_array(['espon','epson2','none','adafruit','epsont81','kiosk','epsont82','rtmobile'])
     
  end
  def self.telcos
    build_array(['edtl','tt','telemor','bwdi'])    
  end
  def self.pulsa_values
      build_array(['1','2','3','5','10','25'])
  end
  def self.pulsa_values_multiselect
       [['3','tt'],['5','tt'],['10','tt'],['2','edtl'],['5','edtl'],['10','edtl'],['25','edtl'],['5','bwdi'],['0','telemor']]  
  end
 
  def self.game_types
    build_array(['4d','3d','2d','combo','combo10'])
  end
  
  def self.upgrade_types
    build_array(['gems','system','sound','script','views'])
  end

  def self.customer_status
     build_array(['none','adrian','bronze','gold','platinum','diamond'])
  end
  
  def self.district_manager_teams
    build_array(['unassigned','None','Ricky','Mili','Belo','Scott'])
  end
  
  def self.report_types
    [['reporting','Simple'],['detail','Detail'],['margin','margin'],['pulsa','pulsa'],['pin','Available pins']]
  end
  
  def self.sub_agent_list
    ['a','b','c','d','e']
  end
    
  end
end
