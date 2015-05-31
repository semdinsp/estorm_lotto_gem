from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
pin=sys.argv[1]
seller=sys.argv[2]
value=sys.argv[3]
printer_type=sys.argv[4]
telco=sys.argv[5]
serial=sys.argv[6]
label=sys.argv[7]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("Successful Load")
pos_printer.println(label)
pos_printer.normal()
pos_printer.println("Value")
pos_printer.println(value)
pos_printer.println("Operator")
pos_printer.println(telco)
pos_printer.println("Serial Number")
pos_printer.println(serial)
pos_printer.end_ticket("Loaded into:",seller)
