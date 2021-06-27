import time

# import numpy as np
# import requests
# import os
# import imutils
# import json
# import redis
# import base64

def OnCameraTick( grabbed , frame ):
	try:
		print( frame )
		time.sleep( 1 )
	except Exception as e:
		print( e )