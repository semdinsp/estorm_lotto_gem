from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os, random
from datetime import datetime, date
from escpos import *
# new scot
import json

msg=sys.argv[1]
printer_type=sys.argv[2]
seller=sys.argv[3]
options=json.loads(sys.argv[4])
title=sys.argv[5]
logo=sys.argv[6]


tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.println(str(options['game_title']))

tms_printer.set_logo(logo)
#end new


pastdraws=options['pastdraws']
shio=options['shio']
ekor=options['ekor']
kapala=options['kapala']
drawtype=options['game_title']
rama=options['rama']
shiolist1="1:Dog-Asu 2:Rat-Laho 3:Pig-Fahi\n4:Cat-Busa 5:Frog-Manduku 6:Sheep-Bibi\n7:Rooster-Manu_aman 8:Horse-Kuda 9:Dragon-Naga"
shiolist2="10:Snake-Samea 11:Tiger-Tigri\n12:Buterfly-Borboleta 13:Crocodile-Lafaek\n14:Crab-kadiuk 15:Monkey-Lekirauk\n16:Scorpion-Sakunar 17:Duck-Manurade\n18:Rabbit-Coelho 19:Fish-Ikan"
shiolist3="20:Cow-Karau 21:Owl-Manu_kakuuk\n22:Goat-Bibi_Malae 23:Eagle-Makikit\n24:Weasel-Laku 25:Deer-Bibi_rusa " 
#shiolist1="1:Dog-Asu 2:Rat-Laho 3:Pig-Fahi 4:Cat-Busa 5:Frog-Manduku 6:Sheep-Bibi 7:Rooster-Manu_aman 8:Horse-Kuda 9:Dragon-Naga 10:Snake-Samea 11:Tiger-Tigri 12:Buterfly-Borboleta 13:Crocodile-Lafaek 14:Crab-kadiuk 15:Monkey-Lekirauk 16:Scorpion-Sakunar 17:Duck-Manurade 18:Rabbit-Coelho 19:Fish-Ikan 20:Cow-Karau 21:Owl-Manu_kakuuk 22:Goat-Bibi_Malae 23:Eagle-Makikit 24:Weasel-Laku 25:Deer-Bibi_rusa " 

#shiolist1="Kambing 10,22,34,46,58,70,82,94\nNaga 01,12,25,37,49,61,73,85\nKelinci 02,14,26,38,50,62,74,86\nMacan 03,15,27,39,51,63,75,87,99\nSapi 04,16,28,40,52,64,6,88,00"
#shiolist2="Tikus 05,17,29,41,53,65,77,89\nBabi 06,18,30,42,54,66,78,90\nAnjing 07,19,31,43,55,67,79,91\nAyam 08,20,32,44,56,68,80,92"
#shiolist3="Monyet 09,21,33,45,57,69,81,93\nKuda 11,23,35,47,59,71,83,95\nUlar 12,24,36,48,60,72,84,96"
year=date.today().year
tms_printer.large()
#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
tms_printer.println("Lucky Ramalan")
tms_printer.normal()
tms_printer.println("Prediksi Tahun Kuda " + str(year))
tms_printer.println(drawtype)
tms_printer.println("Past Draws Date")
tms_printer.println(pastdraws)
tms_printer.println("Shio")
tms_printer.large()
tms_printer.println(shio)
tms_printer.normal()
tms_printer.large()
tms_printer.println(rama[0])
tempstr= rama[1]+" "+rama[2]+" "+rama[3]
tms_printer.println(tempstr)
tms_printer.println(rama[4])
tms_printer.normal()
tms_printer.println("Awas Ekor/Awas Kapala")
tms_printer.large()
tms_printer.println(str(ekor) + " / " + str(kapala))
tms_printer.normal()
tms_printer.print_prizes(drawtype)
# tms_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/"+shio+".jpeg")
tms_printer.space()
tms_printer.println("Your Pairs")
for x in range(0, 4):
    pair='| {} | {} |'.format(random.randint(1, 25), random.randint(1,25))
    tms_printer.println(pair)
tms_printer.space()
randimage=random.sample(['houseline', 'ducattiline', 'carline','roseline'],  1)
tms_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/"+randimage[0]+".jpeg")
tms_printer.println("Shiolist")
tms_printer.println(shiolist1)
tms_printer.println(shiolist2)
tms_printer.println(shiolist3)
tms_printer.tms_end_ticket("Processed by:",seller)
