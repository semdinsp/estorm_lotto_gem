from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
respstring=sys.argv[1]
seller=sys.argv[2]
drawtype=sys.argv[3]
drawdate=sys.argv[4]
md5=sys.argv[5]
printer_type=sys.argv[6]

#res,seller,drawtype,drawdate,md5,printer_type

pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky Loja Ticket")
pos_printer.println("Sorry not a winning ticket")
pos_printer.println(drawtype)
pos_printer.normal()
pos_printer.println("Drawdate")
pos_printer.println(drawdate)
pos_printer.println("Security Code")
pos_printer.println(md5)
pos_printer.space()
pos_printer.println(respstring)
pos_printer.space()
pos_printer.normal()
pos_printer.println("Printed by:\n")
pos_printer.println(seller)
# pos_printer.printBarcode(sec_code, ada_printer.CODE128)
pos_printer.closing()