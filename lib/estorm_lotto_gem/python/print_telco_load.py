from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
import string
pin=sys.argv[1]
seller=sys.argv[2]
value=sys.argv[3]
printer_type=sys.argv[4]
msg=sys.argv[5]
txid=sys.argv[6]
telco=sys.argv[7]
serial=sys.argv[8]
label=sys.argv[9]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
values={}
values['telco']=telco
t = string.Template("TEDS $telco PIN")
pos_printer.println(t.safe_substitute(values))
pos_printer.normal()
pos_printer.println(label)
pos_printer.large()
pos_printer.println(pin)
pos_printer.normal()
pos_printer.println("Value")
pos_printer.println(value)
pos_printer.println("Telco Serial")
pos_printer.println(serial)
pos_printer.println("Message")
pos_printer.println(msg)
pos_printer.println("Telco")
pos_printer.println(telco)
pos_printer.security_code(txid)
pos_printer.end_ticket("Sold by:",seller)
