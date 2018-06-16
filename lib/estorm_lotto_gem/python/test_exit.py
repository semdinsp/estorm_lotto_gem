# from Adafruit_Thermal import *
import  sys, os
from datetime import datetime
# from escpos import *
global brandlogo,brandurl

exitcode=sys.argv[1]
if exitcode=='5':
    raise ValueError('Try expceiotn with exit code 5.')
sys.exit(int(exitcode))