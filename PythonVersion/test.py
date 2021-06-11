import numpy as np
import cv2
import requests
import sys
import os
import signal
import imutils
import json
import redis
import base64
import time
# from datetime import datetime , timedelta , time
#from time import localtime, strftime , sleep
# from pytz import timezone
# eastern_tz = timezone( "US/Eastern" )

# from twilio.rest import Client

import utils
utils.test()
w_Capture = False
def signal_handler( signal , frame ):
	global w_Capture
	message_string = "main.py closed , Signal = " + str( signal )
	print( message_string )
	w_Capture.release()
	cv2.destroyAllWindows()
	sys.exit( 1 )

signal.signal( signal.SIGABRT , signal_handler )
signal.signal( signal.SIGFPE , signal_handler )
signal.signal( signal.SIGILL , signal_handler )
signal.signal( signal.SIGSEGV , signal_handler )
signal.signal( signal.SIGTERM , signal_handler )
signal.signal( signal.SIGINT , signal_handler )

w_Capture = cv2.VideoCapture( 0 )
while( w_Capture.isOpened() ):
	print( "open" )
	( grabbed , frame ) = w_Capture.read()
	if not grabbed:
		print( "can't connect to pi camera" )
		time.sleep( 1 )
		break
	time.sleep( 1 )


w_Capture.release()
cv2.destroyAllWindows()