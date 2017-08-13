from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
import json

msg=sys.argv[1]
printer_type=sys.argv[2]
seller=sys.argv[3]
options=json.loads(sys.argv[4])
title=sys.argv[5]
logo=sys.argv[6]




tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.set_logo(logo)

#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
# pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
tms_printer.space()
tms_printer.println(title)
tms_printer.println("Total: " + str(options['total']))
tms_printer.normal()
tms_printer.println("Txid: " + str(options['id']))
tms_printer.normal()
tms_printer.println("Win count: " + str(options['wincount']))
tms_printer.normal()
tms_printer.println("Fail count: " + str(options['failedcount']))
tms_printer.normal()
tms_printer.println("Winlist:\n " + str(options['winlist']))
#tms_printer.tms_message(msg)
tms_printer.tms_end_ticket("Processed by:",seller)



