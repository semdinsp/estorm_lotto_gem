from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
pastdraws=sys.argv[1]
shio=sys.argv[2]
ekor=sys.argv[3]
kapala=sys.argv[4]
printer_type=sys.argv[5]
seller=sys.argv[6]
drawtype=sys.argv[7]
rama=sys.argv[8]


pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky Loja Ramala")
pos_printer.println(drawtype)
pos_printer.normal()
pos_printer.space()
pos_printer.println("Past Draws Date")
pos_printer.println(pastdraws)
pos_printer.space()
pos_printer.println("Shio")
pos_printer.large()
pos_printer.println(shio)
pos_printer.space()
pos_printer.normal()
pos_printer.println("Ramalan\n")
pos_printer.large()
pos_printer.println(rama[0])
pos_printer.println(rama[1:4])
pos_printer.println(rama[4])
pos_printer.normal()
pos_printer.println("Ekor")
pos_printer.println(ekor)
pos_printer.println("AWAS Kapala")
pos_printer.println(kapala)
pos_printer.normal()
pos_printer.println("Sold by:\n")
pos_printer.println(seller)
# pos_printer.printBarcode(sec_code, ada_printer.CODE128)
pos_printer.closing()