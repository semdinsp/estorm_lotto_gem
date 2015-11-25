from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
seller=sys.argv[1]
value=sys.argv[2]
printer_type=sys.argv[3]
txid=sys.argv[4]
master=sys.argv[5]
label=sys.argv[6]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("Cashout Ticket")
pos_printer.println(label)
pos_printer.normal()
pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
pos_printer.space()
pos_printer.println("Value")
pos_printer.println(value)
pos_printer.println("Master Wallet")
pos_printer.println(master)
pos_printer.txid_code(txid)
pos_printer.end_ticket("Redeemed by:",seller)
