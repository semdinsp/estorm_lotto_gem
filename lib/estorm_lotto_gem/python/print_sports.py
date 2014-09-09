from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
resp=sys.argv[1]
seller=sys.argv[2]
team=sys.argv[3]
txid=sys.argv[4]
printer_type=sys.argv[5]
prize=sys.argv[6]


pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky SMS Football")
pos_printer.println("Game Resuls")
pos_printer.println("Team")
pos_printer.large()
pos_printer.println(team)
pos_printer.println("Game updates")
pos_printer.println(resp)
pos_printer.println("Prize")
pos_printer.large()
pos_printer.println(prize)
pos_printer.space()
pos_printer.security_code(txid)
pos_printer.space()
pos_printer.println("Sold by:")
pos_printer.println(seller)
# pos_printer.printBarcode(sec_code, ada_printer.CODE128)
pos_printer.closing()