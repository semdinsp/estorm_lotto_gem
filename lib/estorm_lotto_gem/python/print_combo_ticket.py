from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
from array import *
numbers=sys.argv[1].split(',')
entries=sys.argv[1]
drawdate=sys.argv[2]
sec_codes=sys.argv[3].split(',')
extra_msg=sys.argv[4]
printer_type=sys.argv[5]
seller=sys.argv[6]
drawtype=sys.argv[7]


pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky SMS Combo Ticket")
pos_printer.draw_info(drawtype,drawdate)
pos_printer.space()
pos_printer.println("Entries")
pos_printer.large()
pos_printer.println(entries)
count=len(numbers)
#indices = [0,1,2,3,4]
for i in range(0,count):
  pos_printer.security_code(sec_codes[i])
pos_printer.println("Extra messages")
pos_printer.println(extra_msg)
pos_printer.end_ticket("Sold by:",seller)



