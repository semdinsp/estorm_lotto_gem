from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys
from datetime import datetime, date
from escpos import *
pastdraws=sys.argv[1]
shio=sys.argv[2]
ekor=sys.argv[3]
kapala=sys.argv[4]
printer_type=sys.argv[5]
seller=sys.argv[6]
drawtype=sys.argv[7]
rama=sys.argv[8]
shiolist1="Kambing 10,22,34,46,58,70,82,94\nNaga 01,12,25,37,49,61,73,85\nKelinci 02,14,26,38,50,62,74,86\nMacan 03,15,27,39,51,63,75,87,99\nSapi 04,16,28,40,52,64,6,88,00"
shiolist2="Tikus 05,17,29,41,53,65,77,89\nBabi 06,18,30,42,54,66,78,90\nAnjing 07,19,31,43,55,67,79,91\nAyam 08,20,32,44,56,68,80,92"
shiolist3="Monyet 09,21,33,45,57,69,81,93\nKuda 11,23,35,47,59,71,83,95\nUlar 12,24,36,48,60,72,84,96"
year=date.today().year
pos_printer=Teds_Printer(printer_type)
pos_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
pos_printer.println("Lucky SMS Ramalan")
pos_printer.println("Prediksi Tahun Kuda " + str(year))
pos_printer.println(drawtype)
pos_printer.normal()
pos_printer.println("Past Draws Date")
pos_printer.println(pastdraws)
pos_printer.println("Shio")
pos_printer.large()
pos_printer.println(shio)
pos_printer.normal()
pos_printer.large()
pos_printer.println(rama[0])
tempstr= rama[1]+" "+rama[2]+" "+rama[3]
pos_printer.println(tempstr)
pos_printer.println(rama[4])
pos_printer.normal()
pos_printer.println("Awas Ekor/Awas Kapala")
pos_printer.println(ekor + " " + kapala)
pos_printer.normal()
pos_printer.print_prizes(drawtype)
pos_printer.println("Shiolist")
pos_printer.println(shiolist1)
pos_printer.println(shiolist2)
pos_printer.println(shiolist3)
pos_printer.end_ticket("Printed by:",seller)
