from Adafruit_Thermal import *
import Image, sys, os
from datetime import datetime
from escpos import *
global brandlogo,brandurl

brandname="Lucky SMS"
class Base_Printer(object):
    def __init__(self,usbid):
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
    def closing(self):
        # do thonthing
        pass
    def image(self,img):
        # do thonthing
        pass
    def security_code(self,code,label):
        print(label)
        print(code)
    

class Ada_Printer(Base_Printer):
    def __init__(self,tty):
        # usbi id 0x0e03
        self.my_printer = Adafruit_Thermal(tty, 19200, timeout=5) 
    def println(self,atext):
        self.my_printer.println(atext)
    def large(self):
        self.my_printer.justify('C')
        self.my_printer.setSize('M')
    def normal(self):
        self.my_printer.setSize('S')
    def space(self):
        self.my_printer.feed(1)
    def image(self,image):
        pass
        # FIX LATER self.my_printer.feed(1)
    def closing(self):
        now=str(datetime.now())
        self.my_printer.setSize('S')
        self.my_printer.println("www.teds-timor.com")
        self.my_printer.setDefault()
        self.my_printer.println(now)
        self.my_printer.feed(3)
        self.my_printer.reset()
    def security_code(self,code,label):
        self.my_printer.setSize('S')
        self.my_printer.println(label)
        self.large()
        self.my_printer.println(code)
        code2=code[-7:]
        self.my_printer.reset()
        self.my_printer.setBarcodeHeight(60)
        self.my_printer.printBarcode(code2.upper(), self.my_printer.CODE39)
        self.my_printer.justify('C') 
        self.normal()

class Epson_Printer(Base_Printer):
    def __init__(self,usbid):
        # usbi id 0x0e03
        self.my_printer = printer.Usb(0x04b8,usbid)
    def println(self,atext):
        if atext == '':
            atext=" "
        self.my_printer.text(atext)
        self.my_printer.text("\n")
    def large(self):
        self.my_printer.set("CENTER","A","B",2,2)
    def image(self,img):
        self.my_printer.image(img)
    def normal(self):
        self.my_printer.set("CENTER","A","normal",1,1)
    def space(self):
        self.my_printer.text("\n")
    def private_closing(self,urlname,imagename):
        now=str(datetime.now())
        self.my_printer.set("CENTER", "A", "normal", 1, 1)
        self.my_printer.text(now+"\n")
        self.image(os.path.dirname(os.path.realpath(__file__))+"/images/"+imagename)
        self.my_printer.text(urlname+"\n")
        self.my_printer.cut()
        self.space()
    def closing(self):
        self.private_closing("www.teds-timor.com","tedslogo.jpeg")
    def tms_closing(self):
        self.private_closing(brandurl,brandlogo)
    def security_code(self,code,label):
        self.normal()
        self.println(label)
        self.large()
        self.println(code)
        self.normal()
        code2=code+"\x00"
        # qr(self, text):
        self.my_printer.barcode(code2.upper(),"CODE39", 54, 2,"OFF","A")
        self.normal()
    def lotto_qr_code(self,code,label):
        self.normal()
        self.println(label)
        self.large()
        self.my_printer.qr(code)
        self.normal()

class Kiosk_Printer(Epson_Printer):
    def __init__(self,usbid):
        # 0483:5840
        self.my_printer = printer.Usb(0x0483,usbid,0,0x81,0x03)
    def image(self,img):
        self.my_printer.text("\n")
        self.my_printer.image(img)

class Kiosk_Imageless_Printer(Epson_Printer):
    def __init__(self,usbid):
        # 0483:5840
        self.my_printer = printer.Usb(0x0483,usbid,0,0x81,0x03)
    def image(self,img):
        pass
        
class Epson_Imageless_Printer(Epson_Printer):
    def image(self,img):
        pass
        
class RTMobile_Printer(Epson_Printer):
    def __init__(self,usbid):
        # 0483:5840
        self.my_printer = printer.Usb(0x067b,usbid,0,0x82,0x02)

class RPP300_BlueToothPrinter(Epson_Printer):
    # Serial("devfile", baudrate, bytesize, timeout)
    def __init__(self):
        # 0483:5840
        self.my_printer = printer.Serial("/dev/rfcomm0")
        
class DPR_Printer(Epson_Printer):
    def __init__(self,usbid):
        # 0483:5840
        self.my_printer = printer.Usb(0x0fe6,usbid,0,0x82,0x02)

class Sgs_Printer(Epson_Printer):
    def __init__(self,usbid):
        # usbi id 0x0e03
        self.my_printer = printer.Usb(0x0483,usbid,0,0x81,0x02) #printer.Usb(0x0483,usbid)    #0483:811e

class Teds_Printer(object):
    def  __init__(self, printer_type):
        self.my_printer="none"
        if printer_type == 'epson':
            self.my_printer = Epson_Printer(0x0e03)
        if printer_type == 'epson2':
            self.my_printer = Epson_Printer(0x0e15)
        if printer_type == 'epsont81':
            self.my_printer = Epson_Printer(0x0202)
        if printer_type == 'epsont81-noimage':
            self.my_printer = Epson_Imageless_Printer(0x0202)
        if printer_type == 'epsont82':
            self.my_printer = Epson_Printer(0x0e11)
        if printer_type == 'kiosk':
            self.my_printer = Kiosk_Printer(0x5840)
        if printer_type == 'kiosk-noimage':
            self.my_printer = Kiosk_Imageless_Printer(0x5840)
        if printer_type == 'rtmobile':
            self.my_printer = RTMobile_Printer(0x2303)
        if printer_type == 'pp02-50mm':
            self.my_printer = RTMobile_Printer(0x2303)
        if printer_type == 'rpp300-bluetooth':
            self.my_printer = RPP300_BlueToothPrinter()
        if printer_type == 'pp02-bluetooth':
            self.my_printer = RPP300_BlueToothPrinter()
        if printer_type == 'dpr801':
            self.my_printer = DPR_Printer(0x811e)
        if printer_type == 'rongta':
            self.my_printer = DPR_Printer(0x811e)
        if printer_type == 'sgsprinter':
            self.my_printer = Sgs_Printer(0x811e)
        if printer_type == 'adafruit':
            self.my_printer = Ada_Printer('/dev/ttyAMA0')
        if self.my_printer == 'none':
            self.my_printer = Base_Printer('test')
    def println(self,atext):
        self.my_printer.println(atext)
    def large(self):
        self.my_printer.large()
    def normal(self):
        self.my_printer.normal()
    def image(self,img):
        self.my_printer.image(img)
    def space(self):
        self.my_printer.space()
    def closing(self):     
        self.my_printer.closing()
    def tms_closing(self):     
        self.my_printer.tms_closing()
    def draw_info(self,drawtype,drawdate):
        self.println(drawtype)
        self.normal()
        self.println("Draw Date")
        self.println(drawdate)
    def secure_end_ticket(self,title,seller,drawtype,drawdate):
        tcode = seller[-4:]+drawtype+drawdate[2:]
        tcode=tcode.replace("-","")
        tcode=tcode.replace("lotto","l")
        tcode=tcode.replace("combo","c")
        self.md5_code(tcode,'Ticket security:')
        self.end_ticket(title,seller)
    def end_ticket(self,title,seller):
        self.normal()
        self.println(title+" "+seller)
        self.closing()
    def tms_end_ticket(self,title,seller):
        self.normal()
        self.println(title+" "+seller)
        self.tms_closing()
    def md5_code(self,code,label):     
        self.my_printer.security_code(code,label)
    def txid_code(self,code):     
        self.my_printer.security_code(code,"Transaction Id")
    def security_code(self,code):     
        self.my_printer.security_code(code,"Security Code") 
    def get_prizes(self,drawtype):
        if drawtype=='4d':
            return ["4D  ------> $3000", "3D -------> $50", "2D -------> $10", "1D ----> Free entry", "Reverse ---> $200", "Consolation -> $50"]
        if drawtype=='combo':
            return ["4D  ------> $690", "3D -------> $90", "2D -------> $10", "Reverse ---> $50"]
        if drawtype=='combo10':
            return ["4D  ------> $200", "3D -------> $5", "2D -------> $1","Reverse ---> $20" ]
        if drawtype=='jogu':
            return ["Red  -----> $500",  "Yellow -----> $200", "Green -----> $100", "Starter ----> $30", "Consolation ---> $15" ]
        if drawtype=='sing':
            return ["4D  ------> $3000",  "3D -------> $50", "2D -------> $10", "1D ----> Free entry", "Reverse ---> $200" ]
        if drawtype=='3d':
            return [ "3D -----> $200"]
        if drawtype=='2d':
            return [ "2D -----> $18"]
    def print_prizes(self,drawtype):
        self.my_printer.println("Prizes:")
        self.my_printer.println('-------------------------')
        prizelist=self.get_prizes(drawtype)
        for item in prizelist:          
            self.my_printer.println(item)
        self.my_printer.println('-------------------------')
    def print_title(self,title):
        self.large()
        #ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
        self.println(title)
        self.normal()
        self.space()
    def set_logo(self,newlogo):
        global brandlogo
        global brandurl
        brandlogo=newlogo+".jpg"
        if newlogo=="timorscratch":
            brandurl="www.timor-scratch.com"
        else:
            brandurl="www.scratchcardlao.com"
    def lotto_qr_code(self,code,label):
        self.my_printer.lotto_qr_code(code,label)
    def print_message(self,msg,title):
        self.print_title(title)
        self.println(msg)
        self.space()
        self.closing()
    def mqtt_message(self,topic,msg):
        self.print_message(msg,"MQTT Message")
    def mqtt_balance(self,topic,msg):
        self.print_title("Terminal Balance")
        self.print_title(str(msg['balance']))
        self.closing()
    def handle_mqtt_message(self,topic,msg,logger):
        topickey=topic.rsplit('/',1)
        method_name = 'mqtt_' + str(topickey[-1])
        method_to_call = getattr(self, method_name)
        logger.debug("TEDSPRINTER OBJECT: handle mqtt mesage: " + method_name + " on topic: "+topic )
        method_to_call(topic,msg)
        

class TMS_Printer(Teds_Printer):   
    def tms_message(self,msg):
        self.print_title("TMS Details")
        self.println(msg)
        self.space
