import signal
import cv2
import sys
import time

import utils

class New:
	def __init__( self , options={} ):
		self.capture = None
		# if "device_id" not in options:
		# 	options["device_id"] = 0
		# self.device_id = options["device_id"]
		self.max_device_id_search = 20
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
	def find_device( self ):
		for i in range( -1 , self.max_device_id_search ):
			try:
				print( f"trying id === {i}" )
				self.capture = cv2.VideoCapture( i )
				print( f"found device on id === {i}" )
				return True
			except Exception as e:
				continue
	def open( self , callback ):
		self.find_device()
		while( self.capture.isOpened() ):
			( grabbed , frame ) = self.capture.read()
			if not grabbed:
				utils.LogGlobal( "can't connect to pi camera" )
				time.sleep( 1 )
				break
			else:
				callback( grabbed , frame )