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
pvalue=sys.argv[6]

printer_type=sys.argv[7]

#res,seller,drawtype,drawdate,md5,printer_type

pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println(brandname+" Ticket")
pos_printer.println("Congrats Winning Ticket")
pos_printer.normal()
pos_printer.draw_info(drawtype,drawdate)
pos_printer.large()
pos_printer.println("Prize Value")
pos_printer.println(pvalue)
pos_printer.normal()
pos_printer.security_code(md5)
pos_printer.space()
pos_printer.println(respstring)
pos_printer.space()
pos_printer.end_ticket("Printed by:",seller)
