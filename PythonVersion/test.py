#!/usr/bin/env python3
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

import utils
utils.test()

# from datetime import datetime , timedelta , time
#from time import localtime, strftime , sleep
# from pytz import timezone
# eastern_tz = timezone( "US/Eastern" )
# from twilio.rest import Client

class PiCamera:
	def __init__( self , options={} ):
		self.capture = None
		if "device_id" not in options:
			options["device_id"] = 0
		self.device_id = options["device_id"]
		signal.signal( signal.SIGABRT , self.signal_handler )
		signal.signal( signal.SIGFPE , self.signal_handler )
		signal.signal( signal.SIGILL , self.signal_handler )
		signal.signal( signal.SIGSEGV , self.signal_handler )
		signal.signal( signal.SIGTERM , self.signal_handler )
		signal.signal( signal.SIGINT , self.signal_handler )
	def signal_handler( self , signal , frame ):
		print( f"\nmain.py closed , Signal = {str(signal)}" )
		self.capture.release()
		cv2.destroyAllWindows()
		sys.exit( 1 )
	def open( self , callback ):
		self.capture = cv2.VideoCapture( self.device_id )
		while( self.capture.isOpened() ):
			( grabbed , frame ) = self.capture.read()
			if not grabbed:
				print( "can't connect to pi camera" )
				time.sleep( 1 )
				break
			else:
				callback()

def test_callback():
	print( "here in the callback" )
	time.sleep( 1 )

if __name__ == "__main__":
	camera = PiCamera()
	print( camera )
	camera.open( test_callback )