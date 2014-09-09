from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
number=sys.argv[1]
drawdate=sys.argv[2]
sec_code=sys.argv[3]
extra_msg=sys.argv[4]
printer_type=sys.argv[5]
seller=sys.argv[6]
drawtype=sys.argv[7]


pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky SMS Ticket")
pos_printer.println(drawtype)
pos_printer.normal()
pos_printer.space()
pos_printer.println("Draw Date")
pos_printer.println(drawdate)
pos_printer.space()
pos_printer.println("Entry")
pos_printer.large()
pos_printer.println(number)
pos_printer.space()
pos_printer.security_code(sec_code)
pos_printer.println("Extra messages")
pos_printer.println(extra_msg)
pos_printer.normal()
pos_printer.println("Sold by:")
pos_printer.println(seller)
# pos_printer.printBarcode(sec_code, ada_printer.CODE128)
pos_printer.closing()


