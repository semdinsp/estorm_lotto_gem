from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
pin=sys.argv[1]
seller=sys.argv[2]
value=sys.argv[3]
printer_type=sys.argv[4]
msg=sys.argv[5]
telco=sys.argv[6]
serial=sys.argv[7]
label=sys.argv[8]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("Successful Load")
pos_printer.println(label)
pos_printer.normal()
pos_printer.println("Value")
pos_printer.println(value)
pos_printer.println("Message")
pos_printer.println(msg)
pos_printer.println("Telco")
pos_printer.println(telco)
pos_printer.normal()
pos_printer.println("Sold by:\n")
pos_printer.println(seller)
pos_printer.closing()