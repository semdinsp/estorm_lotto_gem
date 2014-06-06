from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
team=sys.argv[1]
txid=sys.argv[2]
seller=sys.argv[3]
msgs=sys.argv[4]
printer_type=sys.argv[5]


pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky Loja Football")
pos_printer.println("Instant Win")
pos_printer.println("Team")
pos_printer.large()
pos_printer.println(team)
pos_printer.println("Game updates")
pos_printer.println(msgs)
pos_printer.space()
pos_printer.normal()
pos_printer.println("TXID")
pos_printer.println(txid)
pos_printer.space()
pos_printer.println("Sold by:\n")
pos_printer.println(seller)
# pos_printer.printBarcode(sec_code, ada_printer.CODE128)
pos_printer.closing()