from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
respstring=sys.argv[1]
seller=sys.argv[2]
txtype=sys.argv[3]
printer_type=sys.argv[4]
successflag=sys.argv[5]
txid=sys.argv[6]



pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("TEDS")
pos_printer.println("Transaction Record")
pos_printer.println(txtype)
pos_printer.println(successflag)
pos_printer.normal()
pos_printer.space()
pos_printer.println(respstring)
pos_printer.space()
pos_printer.security_code(txid)
pos_printer.end_ticket("Printed by:",seller)
