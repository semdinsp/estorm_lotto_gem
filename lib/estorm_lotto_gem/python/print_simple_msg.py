from Adafruit_Thermal import *
import Image, sys
from datetime import datetime
from escpos import *
from Teds_Printer import *

msg=sys.argv[1]
printer_type=sys.argv[2]
title=sys.argv[3]

pos_printer=Teds_Printer(printer_type)
pos_printer.print_message(msg,title)
