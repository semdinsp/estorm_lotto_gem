from Adafruit_Thermal import *
import Image, sys
from datetime import datetime
from escpos import *
from Teds_Printer import *

msg=sys.argv[1]
printer_type=sys.argv[2]

pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Error Message")
pos_printer.normal()
pos_printer.space()
pos_printer.println(msg)
pos_printer.space()
pos_printer.closing()
