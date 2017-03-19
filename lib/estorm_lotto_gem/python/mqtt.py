'''
/*
 * Copyright 2010-2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
 '''

from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import sys
import logging
import time
import getopt
import Teds_Printer
from Teds_Printer import *
# Custom MQTT message callback
def customCallback(client, userdata, message):
  print("Received a new message: ")
  print(message.payload)
  print("from topic: ")
  print(message.topic)
  print("--------------\n\n")
  pos_printer=Teds_Printer(printerType)
  pos_printer.print_message(message.payload,'MQTT  Message')
  logger.debug("received: " + message.payload + " on topic: "+message.topic + " printer type: " + printerType)

# Usage
usageInfo = """Usage:

Use certificate based mutual authentication:
python mqtt.py -i identity -p printertype


Type "python mqtt.py -h" for available options.
"""
# Help info
helpInfo = """-g, --gem
	Path to gemfiles
-h, --help
	Help information
-i, --identity
	Terminal identity
-p, --printer
	Termintal printer type


"""
try:
        opts, args = getopt.getopt(sys.argv[1:], "hg:p:i:", ["help", "gem=" ,"printer=", "identity="])
        if len(opts) == 0:
                raise getopt.GetoptError("No input parameters!")
        for opt, arg in opts:
                if opt in ("-h", "--help"):
                        print(helpInfo)
                        exit(0)
                if opt in ("-g", "--gem"):
                        gpath = arg
                if opt in ("-p", "--printer"):
                        printerType = arg
                        print("Printer type set to: "+printerType)
                if opt in ("-i", "--identity"):
                        identity = arg
                        print("Identity  set to: "+identity)
except getopt.GetoptError:
        print(usageInfo)
        exit(1)

# sys.path.append(gpath)   SCOTT

#printer_type='dpr801'
#print("python gem path: " + gpath)
# Read in command-line parameters
useWebsocket = False
#SCOTT  MAYBE MAKE THIS CONFIGURABLE
host = "a36q3zlv5b6zdr.iot.ap-southeast-1.amazonaws.com"
certdir="/boot/config/certs/"
rootCAPath = certdir+"root-CA.crt"
certificatePath = certdir+identity+".cert.pem"
privateKeyPath = certdir+identity+".private.key"


# Missing configuration notification
missingConfiguration = False
if not host:
	print("Missing '-e' or '--endpoint'")
	missingConfiguration = True
if not rootCAPath:
	print("Missing '-r' or '--rootCA'")
	missingConfiguration = True
if not useWebsocket:
	if not certificatePath:
		print("Missing '-c' or '--cert'")
		missingConfiguration = True
	if not privateKeyPath:
		print("Missing '-k' or '--key'")
		missingConfiguration = True
if missingConfiguration:
	exit(2)

# Configure logging
logger = logging.getLogger("AWSIoTPythonSDK.core")
logger.setLevel(logging.DEBUG)
streamHandler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
streamHandler.setFormatter(formatter)
logger.addHandler(streamHandler)

# Init AWSIoTMQTTClient
myAWSIoTMQTTClient = None
myAWSIoTMQTTClient = AWSIoTMQTTClient(identity+"-thing-printer")
myAWSIoTMQTTClient.configureEndpoint(host, 8883)
myAWSIoTMQTTClient.configureCredentials(rootCAPath, privateKeyPath, certificatePath)

# AWSIoTMQTTClient connection configuration
myAWSIoTMQTTClient.configureAutoReconnectBackoffTime(1, 32, 20)
myAWSIoTMQTTClient.configureOfflinePublishQueueing(-1)  # Infinite offline Publish queueing
myAWSIoTMQTTClient.configureDrainingFrequency(2)  # Draining: 2 Hz
myAWSIoTMQTTClient.configureConnectDisconnectTimeout(20)  # 10 sec
myAWSIoTMQTTClient.configureMQTTOperationTimeout(15)  # 5 sec

# Connect and subscribe to AWS IoT
myAWSIoTMQTTClient.connect()
logger.debug("MQTT TEDS Client startup: identity: "+identity+" printer: "+str(printerType))
printertopic="terminal/"+identity+"/#"
myAWSIoTMQTTClient.subscribe(printertopic, 1, customCallback)
logger.debug("subscribed to:" + printertopic +" and all subtopics")
time.sleep(2)

# Publish to the same topic in a loop forever
loopCount = 0
while True:
    # should check and reconnect if discussoned
	time.sleep(1)


