from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime
from escpos import *
from array import *
import string
numbers=sys.argv[1].split(',')
entries=sys.argv[1]
drawdate=sys.argv[2]
sec_codes=sys.argv[3].split(',')
extra_msg=sys.argv[4]
printer_type=sys.argv[5]
seller=sys.argv[6]
drawtype=sys.argv[7]
count=len(numbers)

pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
if drawtype=="combojogu":
  pos_printer.println(brandname + " Jogu Ticket")
  tval=count*0.25
  pos_printer.println("Ticket Value: "+tval)
else:
  pos_printer.println(brandname + " Combo Ticket")
pos_printer.draw_info(drawtype,drawdate)
pos_printer.space()
pos_printer.println("Entries")
pos_printer.large()
if count <= 5:
  pos_printer.println(entries)
else:
  values={}
  for i in range(0,10):
    key='entry{z}'.format(z=i)
    values[key]=''
    if i < count:
      values[key]=numbers[i]
  t = string.Template("$entry0,$entry1,$entry2,$entry3,$entry4")
  t2 = string.Template("$entry5,$entry6,$entry7,$entry8,$entry9")
  pos_printer.println(t.safe_substitute(values))
  pos_printer.println(t2.safe_substitute(values))
#indices = [0,1,2,3,4]
for i in range(0,count):
  pos_printer.security_code(sec_codes[i])
if extra_msg!="none":
  pos_printer.println("Extra messages")
  pos_printer.println(extra_msg)
pos_printer.end_ticket("Sold by:",seller)



