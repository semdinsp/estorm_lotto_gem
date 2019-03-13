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
    'la':{"title": u'ການນັບໃບຫວຍຜິດຜາດ', "prize":u"ລາງວັນ ","game":u"ເກມ ", "total":u"ຍອດລວມ","txid": u"ລະຫັດການເຄືອນໄຫວ ", "win": u"ຢັ້ງຢືນການນັບຜູ້ຖືກລາງວັນ ", "fail": u"ການນັບໃບຫວຍຜິດຜາດ"},
    'en': {"title":"Fail Ticket Receipt", "prize":"Prize ","game":"Game ", "total":"Total ", "txid": "Tx ID: ","win": "Win Count ","fail": "Failed Count "}
}

tms_printer=TMS_Printer(printer_type)
tms_printer.large()
tms_printer.set_logo(logo)
tms_printer.set_locale(options['locale'])


#ada_printer.printImage(Image.open('/home/pi/Python-Thermal-Printer/gfx/luckysms.png'), True)
# pos_printer.image(os.path.dirname(os.path.realpath(__file__))+"/images/santa.jpeg")
tms_printer.space()
if tms_printer.locale=="la":
    #print lao first
    tms_printer.translated_println(translations[options["locale"]]["title"]) 
tms_printer.println(title)

tms_printer.normal()
#tms_printer.println("Txid: " + str(options['id']))
tms_printer.translated_println(translations[options["locale"]]["txid"]+ str(options['id']))

tms_printer.normal()
#tms_printer.println("Fail count: " + str(options['failedcount']))
tms_printer.translated_println(translations[options["locale"]]["fail"]+ str(options['failedcount']))

tms_printer.normal()
tms_printer.println("Faillist:\n " + str(options['faillist']))
#tms_printer.tms_message(msg)
tms_printer.println("\n")
tms_printer.println("Term email: " + str(options['email']))
tms_printer.tms_end_ticket("Processed by:",seller)



