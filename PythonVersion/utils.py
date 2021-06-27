import os
import json
from pathlib import Path
import binascii
import datetime
from pytz import timezone
import logging
from logging.handlers import RotatingFileHandler

#from time import localtime, strftime , sleep
#

import redis
# import redis_circular_list
# https://github.com/48723247842/RedisCirclularList/blob/master/redis_circular_list/__init__.py
# next_in_circular_list = redis_circular_list.next( redis_connection , "LIST_KEY" )
# previous_in_circular_list = redis_circular_list.previous( redis_connection , "LIST_KEY" )

# RUNTIME Global Variables
CONFIG_FILE_PATH = None
REDIS_CONNECTION = None
CONFIG = None
ALLOWED_TYPES = [ "list" , "dict" , "int" , "str" ]

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
	global ALLOWED_TYPES
	message_type = type( message ).__name__
	if message_type in ALLOWED_TYPES:
		message = f"{now_time_string()} === {message}"
	else:
		message = f"{now_time_string()} === {str(message)}"
	logging.debug( message )
	redis_log_global( message )
	print( message )

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

def now_time_string():
	global CONFIG
	now = datetime.datetime.now( timezone( CONFIG["misc"]["time_zone"] ) )
	milliseconds = round( now.microsecond / 1000 )
	now_string = now.strftime( CONFIG["misc"]["now_time_string"] )
	return f"{now_string}.{milliseconds}"


def redis_log_global( message ):
	global CONFIG
	global REDIS_CONNECTION
	# global ALLOWED_TYPES
	# message_type = type( message ).__name__
	# if message_type not in ALLOWED_TYPES:
	# 	message = str( message )
	now = datetime.datetime.now( timezone( CONFIG["misc"]["time_zone"] ) )
	day = now.strftime( "%d" )
	month = now.strftime( "%^b" )
	year = now.strftime( "%Y" )
	redis_key = f'{CONFIG["redis"]["keys"]["prefix"]}{CONFIG["redis"]["keys"]["log"]["global"]}{year}.{month}.{day}'
	REDIS_CONNECTION.rpush( redis_key , message )