from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
drawtype=sys.argv[1]
seller=sys.argv[2]
sold=sys.argv[3]
printer_type=sys.argv[4]
drawdate=sys.argv[5]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("Soldout")
pos_printer.draw_info(drawtype,drawdate)
pos_printer.println("Sold Out entries")
pos_printer.println(sold)
pos_printer.end_ticket("Printed by:",seller)
