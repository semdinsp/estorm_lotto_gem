from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
import json

msg=sys.argv[1]
printer_type=sys.argv[2]
seller=sys.argv[3]
title=sys.argv[4]
logo=sys.argv[5]




tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.set_logo(logo)
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
# pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
tms_printer.space()
tms_printer.println(title)
tms_printer.normal()
tms_printer.tms_message(msg)
tms_printer.tms_end_ticket("Processed by:",seller)



