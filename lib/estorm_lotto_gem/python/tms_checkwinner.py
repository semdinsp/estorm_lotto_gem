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
if options['validated']:
  tms_printer.println("ALREADY PAID ")
  tms_printer.space()

if str(options['prize'])=="1250":
    tms_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/motorcycle.jpg")
else:
    tms_printer.println("Prize: " + str(options['prize']))
    tms_printer.normal()
    tms_printer.println("Prize Value: " + str(options['prize_value']))
tms_printer.normal()
tms_printer.println("Game: " + str(options['game']))
tms_printer.normal()
tms_printer.println("Terminal: " + str(options['terminal']))
tms_printer.println("Msg: " + str(options['msg']))
tms_printer.println("Term email: " + str(options['email']))

#tms_printer.tms_message(msg)
tms_printer.tms_end_ticket("Processed by:",seller)



