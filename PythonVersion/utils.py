import logging
from logging.handlers import RotatingFileHandler
import datetime
import os
import binascii

logging.basicConfig(
	filename = f"./LOGS/{datetime.date.today().strftime('%d%^b%Y')}-RUNID-{binascii.b2a_hex(os.urandom(5)).decode('utf-8')}.log" ,
	level = logging.DEBUG ,
	filemode = "w" ,
	# format = " %(asctime)s: (%(filename)s): %(levelname)s: %(funcName)s Line: %(lineno)d - %(message)s" ,
	format = "%(asctime)s: === %(message)s" ,
	datefmt = "%d%^b%Y %H:%M:%S" ,
)
# GLOBAL_LOGGER = logging.getLogger( "global_logger" )
# handler = RotatingFileHandler( "custom_log_output.log" , maxBytes=2000 , backupCount=10 )
# GLOBAL_LOGGER.addHandler( handler )

def LogGlobal( message ):
	# global GLOBAL_LOGGER
	# GLOBAL_LOGGER.debug( message )
	logging.debug( message )
	print( message )

def test():
	print( "here" )