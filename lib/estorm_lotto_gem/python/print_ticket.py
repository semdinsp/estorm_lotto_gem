from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
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
# pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
pos_printer.space()
pos_printer.println(brandname+" Ticket")
pos_printer.draw_info(drawtype,drawdate)
pos_printer.println("Entry")
pos_printer.large()
pos_printer.println(number)
pos_printer.space()
pos_printer.security_code(sec_code)
if extra_msg!="none":
  pos_printer.println("Extra messages")
  pos_printer.println(extra_msg)
pos_printer.end_ticket("Sold by:",seller)



