from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
rtype=sys.argv[1]
seller=sys.argv[2]
invoice_value=sys.argv[3]
invoice=sys.argv[4]
printer_type=sys.argv[5]
txid=sys.argv[6]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("TEDS Invoice Receipt")
pos_printer.println(rtype)
pos_printer.normal()
pos_printer.println("Invoice Number")
pos_printer.println(invoice)
pos_printer.println("Invoice Value")
pos_printer.println(invoice_value)
pos_printer.security_code(txid)
pos_printer.end_ticket("Sold by:",seller)
