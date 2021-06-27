import os
import json
from pathlib import Path
import binascii
import datetime
import logging
from logging.handlers import RotatingFileHandler

import redis
# import redis_circular_list
# https://github.com/48723247842/RedisCirclularList/blob/master/redis_circular_list/__init__.py
# next_in_circular_list = redis_circular_list.next( redis_connection , "LIST_KEY" )
# previous_in_circular_list = redis_circular_list.previous( redis_connection , "LIST_KEY" )

def write_json( file_path , python_object ):
	with open( file_path , 'w', encoding='utf-8' ) as f:
		json.dump( python_object , f , ensure_ascii=False , indent=4 )

def read_json( file_path ):
	with open( file_path ) as f:
		return json.load( f )

logging.basicConfig(
	filename = f"./LOGS/{datetime.date.today().strftime('%d%^b%Y')}-RUNID-{binascii.b2a_hex(os.urandom(5)).decode('utf-8')}.txt" ,
	level = logging.DEBUG ,
	filemode = "w" ,
	format = "%(asctime)s: === %(message)s" ,
	datefmt = "%d%^b%Y %H:%M:%S" ,
)
def LogGlobal( message ):
	logging.debug( message )
	redis_log_global( message )
	print( message )

# RUNTIME Global Variables
CONFIG_FILE_PATH = None
REDIS_CONNECTION = None
CONFIG = None

def Init():
	global CONFIG_FILE_PATH
	global REDIS_CONNECTION
	global CONFIG
	CONFIG_FILE_PATH = Path.home().joinpath( ".config" , "personal" , "motion_alarm.json" )
	if CONFIG_FILE_PATH.is_file() == False:
		LogGlobal( "~./config/personal/motion_alarm.json not found" )
		sys.exit( 1 )
	CONFIG = read_json( CONFIG_FILE_PATH )
	redis_reconnect()

def redis_reconnect():
	global REDIS_CONNECTION
	global CONFIG
	REDIS_CONNECTION = redis.StrictRedis(
		host=CONFIG["redis"]["host"] ,
		port=CONFIG["redis"]["port"] ,
		db=CONFIG["redis"]["database_number"] ,
		password=CONFIG["redis"]["password"] ,
		# decode_responses=True ,
		)
	LogGlobal( REDIS_CONNECTION )

allowed_types = [ "list" , "dict" , "int" , "str" ]
def redis_log_global( message ):
	global allowed_types
	message_type = type( message ).__name__
	if message_type not in allowed_types:
		message = str( message )
	REDIS_CONNECTION.rpush( f'{CONFIG["redis"]["keys"]["prefix"]}{CONFIG["redis"]["keys"]["log"]["global"]}' , message )