#!/usr/bin/python
# -*- coding: utf-8 -*-
from Adafruit_Thermal import *
from Teds_Printer import *
import Image, sys, os
from datetime import datetime
from escpos import *
import json

msg=sys.argv[1]
printer_type=sys.argv[2]
seller=sys.argv[3]
options=json.loads(sys.argv[4])
title=sys.argv[5]
logo=sys.argv[6]
translations = {
    'la':{"title": u'ບັນທືກ ', "total":u"ຍອດລວມ ","pv":"Prize Value","vals": "Validations ","txid": u"ລະຫັດການເຄືອນໄຫວ "},
    'en': {"title":"Credit Note", "total":"Total ","pv":"Prize Value","vals": "Validation List ","txid": "TX ID: "}
}




tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.set_logo(logo)
tms_printer.set_locale(options['locale'])


#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
# pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
if tms_printer.locale=="la":
    #print lao first
    tms_printer.translated_println(translations[options["locale"]]["title"]) 
tms_printer.println(title)
tms_printer.space()
tms_printer.normal()
tms_printer.translated_println(translations[options["locale"]]["txid"]+ str(options['id']))
tms_printer.normal()
tms_printer.translated_println(translations[options["locale"]]["total"]+str(options['total']))
#tms_printer.println("Total: " + str(options['total']))
#tms_printer.println(str(options['total']))

tms_printer.normal()
tms_printer.translated_println(translations[options["locale"]]["vals"])
tms_printer.println(str(options['vals']))
#tms_printer.tms_message(msg)
tms_printer.println("\n")
tms_printer.println("Term email: " + str(options['email']))
tms_printer.tms_end_ticket("Processed by:",seller)



