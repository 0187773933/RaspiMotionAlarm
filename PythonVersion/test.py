#!/usr/bin/env python3
import time
import utils
import picamera

# from datetime import datetime , timedelta , time
#from time import localtime, strftime , sleep
# from pytz import timezone
# eastern_tz = timezone( "US/Eastern" )
# from twilio.rest import Client

# import numpy as np
# import requests
# import os
# import imutils
# import json
# import redis
# import base64

def test_callback():
	utils.LogGlobal( "here in the callback" )
	time.sleep( 1 )

if __name__ == "__main__":
	utils.Init()
	camera = picamera.New()
	utils.LogGlobal( camera )
	camera.open( test_callback )