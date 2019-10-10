from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
import json

# SCOTT I THINK THIS IS NOT USED

msg=sys.argv[1]
printer_type=sys.argv[2]
seller=sys.argv[3]
options=json.loads(sys.argv[4])
title=sys.argv[5]
logo=sys.argv[6]


tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.println(str(options['game_title']))

tms_printer.set_logo(logo)

#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
# pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
tms_printer.space()
tms_printer.println(title)
tms_printer.println("Date: " + str(options['drawdate']))
if str(options['payout'])=="1250.00":
    tms_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/motorcyle.jpg")
else:
    tms_printer.println("Prize: " + str(options['payout']))
tms_printer.space()
if str(options['game_title'])=="powerball":
    tms_printer.println("Digits: " + str(options['digits']))
    tms_printer.println("Powerball: " + str(options['powerball']))
else:
    tms_printer.println("Digits: " + str(options['digits']))
tms_printer.normal()
tms_printer.println("Price: " + str(options['ticket_count']))
tms_printer.space()
tms_printer.tms_end_ticket("Processed by:",seller)



