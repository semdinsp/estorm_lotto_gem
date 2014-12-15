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
txid=sys.argv[6]
telco=sys.argv[7]
serial=sys.argv[8]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("TEDS Pulsa PIN")
pos_printer.println(pin)
pos_printer.normal()
pos_printer.println("Value")
pos_printer.println(value)
pos_printer.println("Telco Serial Number")
pos_printer.println(serial)
pos_printer.println("Message")
pos_printer.println(msg)
pos_printer.println("Telco")
pos_printer.println(telco)
pos_printer.security_code(txid)
pos_printer.normal()
pos_printer.println("Sold by:\n")
pos_printer.println(seller)
pos_printer.closing()