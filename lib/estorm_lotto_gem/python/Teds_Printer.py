from Adafruit_Thermal import *
import Image, sys
from datetime import datetime
from escpos import *

class Base_Printer(object):
    def __init__(self,usbid):
        # usbi id 0x0e03
        pass
    def println(self,atext):
        print(atext)
    def large(self):
        # do nothing
        pass
    def normal(self):
        # do nothing
        pass
    def space(self):
        # do thonthing
        pass

class Ada_Printer(Base_Printer):
    def __init__(self):
        # usbi id 0x0e03
        self.my_printer = Adafruit_Thermal("/dev/ttyAMA0", 19200, timeout=5) 
    def println(self,atext):
        self.my_printer.text(atext)
    def large(self):
        self.my_printer.justify('C')
        self.my_printer.setSize('L')
    def normal(self):
        self.my_printer.setSize('M')
    def space(self):
        self.my_printer.feed(1)
    def closing(self):
        now=str(datetime.now())
        self.my_printer.setSize('S')
        self.my_printer.println("www.lucky-sms.net")
        self.my_printer.setDefault()
        self.my_printer.println(now)
        self.space()

class Epson_Printer(Base_Printer):
    def __init__(self,usbid):
        # usbi id 0x0e03
        self.my_printer = printer.Usb(0x04b8,usbid)
    def println(self,atext):
        self.my_printer.text(atext)
        self.my_Printer.text("\n")
    def large(self):
        self.my_printer.set("CENTER","A","B",2,2)
    def normal(self):
        self.my_printer.set("CENTER","A","normal",1,1)
    def space(self):
        self.my_printer.text("\n")
    def closing(self):
        now=str(datetime.now())
        self.my_printer.set("CENTER", "A", "normal", 1, 1)
        self.my_printer.text("www.lucky-sms.net\n")
        self.my_printer.text(now)
        self.space()
        self.my_printer.cut()

class Teds_Printer(object):
    def  __init__(self, printer_type):
        self.my_printer="none"
        if printer_type == 'epson':
            self.my_printer = Epson_Printer(0x0e03)
        if printer_type == 'epson2':
            self.my_printer = Epson_Printer(0x0e15)
        if printer_type == 'adafruit':
            self.my_printer = Ada_Printer()
        if self.my_printer == 'none':
            self.my_printer = Base_Printer()
    def println(self,atext):
        self.my_printer.println(atext)
    def large(self):
        self.my_printer.large()
    def normal(self):
        self.my_printer.normal()
    def space(self):
        self.my_printer.space()
    def closing(self):     
        self.my_printer.closing()   