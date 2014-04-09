from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
respstring=sys.argv[1]
seller=sys.argv[2]
drawtype=sys.argv[3]
printer_type=sys.argv[4]



pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky Loja")
pos_printer.println("Winning Tickets")
pos_printer.println(drawtype)
pos_printer.normal()
pos_printer.space()
pos_printer.println(respstring)
pos_printer.space()
pos_printer.normal()
pos_printer.println("Printed by:\n")
pos_printer.println(seller)
# pos_printer.printBarcode(sec_code, ada_printer.CODE128)
pos_printer.closing()