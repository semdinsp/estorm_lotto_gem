from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
import json
from time import sleep


msg=sys.argv[1]
printer_type=sys.argv[2]
seller=sys.argv[3]
options=json.loads(sys.argv[4])
title=sys.argv[5]
logo=sys.argv[6]


tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.println(str(options['game_title']))
tms_printer.normal()
tms_printer.set_logo(logo)

#  
for listoptions in options['list']:
    tms_printer.normal()
    #tms_printer.println("Ticket Count: " + str(options['ticket_count']))
    tms_printer.println(str(listoptions))
    

tms_printer.space()    
    
#tms_printer.lotto_qr_code(options['qrcodelist'],"security code")
tms_printer.println("Wallet Source: " + str(options['wallet_identity']))
tms_printer.tms_end_ticket("Processed by:",seller)
    
    



