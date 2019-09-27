module EstormLottoGem
  class Constants
    def self.sw_modules
      build_array(['4d','3d','2d','sport','combo','product','combo10','jogu'])
      
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
       'WalletProcessPayout','WalletUpdatePin','TedsSimpleReporting','WalletLottojogu','WalletLotto4d','Lotto3d','WalletCheckPayout',
       'WalletReload',  'WalletTransfer','WalletInstantLocal','SmsProperties',"WalletInvoice",'WalletLottosing','WalletLottoshio','WalletLotto625','WalletLotto636',
      'WalletLotto3d','WalletTelcoTransfer','Heineken','WalletLotto2d','Cockfighting','SantaSms','SantaWallet','LearningChannel',
       'Bible','Donation','WalletPromotion','WalletCashout','MqttBase','WalletSoldOut','WalletSantaPayout',  
       'WalletLottocombo','WalletRetailProduct','WalletTelcoLoad'])
  end
   def self.printer_types
     build_array(['espon','epson2','none','adafruit','epsont81','epsont81-noimage','rongta','rongta50mm',
             'pp02-50mm','pp02-bluetooth','kiosk','epsont82','rtmobile','rpp300-bluetooth','dpr801','kiosk-noimage'])
     
  end
  def self.telcos
    build_array(['edtl','tt','telemor','bwdi','heineken'])    
  end
  def self.scratch_logos
    build_array(['estormcrm','timorscratch','scratchlao','timortoto','furak'])    
  end
  def self.pulsa_values
      build_array(['1','0.5','2','3','5','10','25'])
  end
  def self.pulsa_values_multiselect
       [['1','tt'],['2','tt'],['3','tt'],['5','tt'],['10','tt'],['2','edtl'],['5','edtl'],['10','edtl'],['25','edtl'],['5','bwdi'],['0','telemor']]  
  end
 
  def self.game_types
    #build_array(['4d','3d','2d','combo','combo10','jogu','sing'])
    build_array(['4d','3d','2d','combo','combo10','jogu','shio'])
  end
  
  def self.shio_list
[["1","Dog-Asu"],
["2","Rat-Laho"],["3","Pig-Fahi"],["4","Cat-Busa"],["5","Frog-Manduku"],["6","Goat-Bibi"],["7","Rooster-Manu_aman"],
["8","Horse-Kuda"],["9","Dragon-Naga"],["10","Snake-Samea"],["11","Tiger-Tigri"],
["12","Buterfly-Borboleta"],["13","Crocodile-Lafaek"],
["14","Crab-kadiuk"],["15","Monkey-Lekirauk"],["16","Scorpion-Sakunar"],["17","Duck-Manurade"],["18","Rabbit-Coelho"],["19","Fish-Ikan"],
["20","Cow-Karau"],["21","Owl-Manu_kakuuk"],["22","Sheep-Bibi_Malae"],["23","Eagle-Makikit"],
["24","Weasel-Laku"],["25","Deer-Bibi_rusa"]]
  end
  
  def  self.get_shio_name(num)
    shiolist=self.shio_list
    index=num.to_i-1  
    "#{shiolist[index][0]}:#{shiolist[index][1]}"
  end
  
  # def self.shio_list_old
   # [['01','Avestruz (Ostrich)'],['02','Aguia (Eagle)'],['03','Burro (Donkey)'],['04','Borboleta (Butterfly)'],
  #  ['05','Anjing-Cachorro (Dog)'],['06','Cabra (Goat)'],
  #  ['07','Carneiro (Ram)'],['08','Camelo (Camel)'],['09','Naga-Cobra (Snake)'],
  #  ['10','Coelho (Rabbit)'],['11','Cavalo (Horse)'],
  #  ['12','Elefante (Elephant)'],['13','Galo (Rooster)'],['14','Gato (Cat)'],['15','Jacare (Caiman)'],
  #  ['16','Leao (Lion)'], ['17','Monyet-Macaco (Monkey)'],['18','Porco (Pig)'],
  #  ['19','Pavao (Peacock)'],['20','Peru (Turkey)'],['21','Touro (Bull)'],
  #  ['22','Tigre (Tiger)'],['23','Urso (Bear)'],['24','Veado (Deer)'],['25','Vaca (Cow)']]
  #end
  
  def self.locales
    build_array(['en','la','tet'])
  end
  def self.timezones
    build_array(['Asia/Dili','Asia/Vientiane','Asia/Singapore'])
  end
  def self.upgrade_types
    build_array(['gems','system','sound','script','views','bundle','scratch','scratch_vmbox','scdirectory','scdirectory_vmbox'])
  end

  def self.customer_status
     build_array(['none','adrian','bronze','gold','platinum','diamond'])
  end
  
  def self.district_manager_teams
    build_array(['unassigned','None','Cancio','Zeferino','Hermenio','Mgmt','scott'])
  end
  
  def self.report_types
    [['reporting','Simple'],['detail','Detail'],['margin','margin'],['daily','Daily Reports'],['pulsa','pulsa'],['pin','Available pins']]
  end
  
  def self.sub_agent_list
    ['a','b','c','d','e']
  end
    
  def self.get_animal(digits)
    list=EstormLottoGem::Constants.shio_list
    idigits = digits.to_i rescue 0
    key = idigits % 25 + 1
    puts "get animal: digits #{digits} idigis #{idigits} key: #{key}"
    animal='unknown'
    list.each {|li|  animal=li[1] if key==li[0].to_i}
    animal
  end
  end
end
