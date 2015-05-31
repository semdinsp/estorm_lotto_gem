from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
rtype=sys.argv[1]
seller=sys.argv[2]
price=sys.argv[3]
custname=sys.argv[4]
printer_type=sys.argv[5]
sku=sys.argv[6]
txid=sys.argv[7]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("TEDS")
pos_printer.println("Sales Receipt")
pos_printer.println(rtype)
pos_printer.normal()
pos_printer.println("Product")
pos_printer.println(sku)
pos_printer.println("Customer")
pos_printer.println(custname)
pos_printer.println("Price")
pos_printer.println(price)
pos_printer.security_code(txid)
pos_printer.end_ticket("Sold by:",seller)
