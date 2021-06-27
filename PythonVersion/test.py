#!/usr/bin/env python3
import time
import utils
import picamera
import motion

# def CameraReadTick():
# 	utils.LogGlobal( "here in the callback" )
# 	time.sleep( 1 )

if __name__ == "__main__":
	utils.Init()
	camera = picamera.New()
	utils.LogGlobal( camera )
	camera.open( motion.OnCameraTick )