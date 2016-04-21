from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
winner=sys.argv[1]
prize=sys.argv[2]
printer_type=sys.argv[3]
txid=sys.argv[4]
prizetype=sys.argv[5]
label=sys.argv[6]
seller=sys.argv[7]
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
pos_printer.println("Promo Hadiah Ticket")
pos_printer.println(label)
pos_printer.normal()
#pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
pos_printer.space()
pos_printer.println("Prize Value")
pos_printer.println(prize)
pos_printer.println(prizetype)
pos_printer.println("Winning Customer")
pos_printer.println(winner)
pos_printer.txid_code(txid)
pos_printer.end_ticket("Redeemed by:",seller)
