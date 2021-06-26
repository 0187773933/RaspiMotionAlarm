import signal
import cv2
import sys
import time

import utils

class New:
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
		utils.LogGlobal( f"main.py closed , Signal = {str(signal)}" )
		self.capture.release()
		cv2.destroyAllWindows()
		sys.exit( 1 )
	def open( self , callback ):
		self.capture = cv2.VideoCapture( self.device_id )
		while( self.capture.isOpened() ):
			( grabbed , frame ) = self.capture.read()
			if not grabbed:
				utils.LogGlobal( "can't connect to pi camera" )
				time.sleep( 1 )
				break
			else:
				callback()