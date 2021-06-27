import time
import imutils
import cv2

import utils

# import numpy as np
# import requests
# import os
# import json
# import redis
# import base64


class New():
	def __init__( self , options ):
		self.options = options
		self.opencv_config = utils.CONFIG["opencv"]
		self.config = utils.CONFIG["programs"]["motion"]
		self.average = None
		self.motion_counter = 0
		self.frame = None
		self.grey = None
		self.delta = None
		self.threshold = None
		self.movement_detected = False

	def resize_frame( self , frame ):
		frame = imutils.resize( frame , width=self.opencv_config["frame"]["width"] )
		x1 = self.opencv_config["frame"]["clipping"]["x"]["1"]
		x2 = self.opencv_config["frame"]["clipping"]["x"]["2"]
		y1 = self.opencv_config["frame"]["clipping"]["y"]["1"]
		y2 = self.opencv_config["frame"]["clipping"]["y"]["2"]
		self.frame = frame[ y1:y2 , x1:x2 ]

	def get_greyscale( self ):
		self.gray = cv2.cvtColor( self.frame , cv2.COLOR_BGR2GRAY )
		self.gray = cv2.GaussianBlur( self.gray , ( 21 , 21 ) , 0 )

	def get_delta( self ):
		if self.average is None:
			self.average = self.gray.copy().astype( "float" )
		cv2.accumulateWeighted( self.gray , self.average , 0.5 )
		self.delta = cv2.absdiff( self.gray , cv2.convertScaleAbs( self.average ) )

	def get_threshold( self ):
		threshold = cv2.threshold( self.delta , self.config["delta_threshold"] , 255 , cv2.THRESH_BINARY )[ 1 ]
		self.threshold = cv2.dilate( threshold , None , iterations=2 )

	def search_for_movement( self ):
		( contours , _ ) = cv2.findContours( self.threshold.copy() , cv2.RETR_EXTERNAL , cv2.CHAIN_APPROX_SIMPLE )
		motion_frames = 0
		for contour in contours:
			if cv2.contourArea( contour ) > self.config["min_area"]:
				motion_frames += 1
		print( motion_frames )
		if motion_frames > self.config["min_motion_frames"]:
			self.options["on_motion_frame"]( self.frame )

	def OnCameraTick( self , grabbed , frame ):
		try:
			self.resize_frame( frame )
			self.get_greyscale()
			self.get_delta()
			self.get_threshold()
			self.search_for_movement()
			# time.sleep( .3 )
		except Exception as e:
			print( e )