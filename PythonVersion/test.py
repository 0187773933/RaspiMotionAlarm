#!/usr/bin/env python3
import time
import utils
import picamera
import motion

def OnMotionFrame( frame ):
	print( "here in on motion frame callback" )
	print( frame )

if __name__ == "__main__":
	utils.Init()
	camera = picamera.New()
	utils.LogGlobal( camera )
	motion_detector = motion.New({
		"on_motion_frame": OnMotionFrame
	})
	camera.open( motion_detector.OnCameraTick )