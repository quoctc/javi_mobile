import time
from threading import Thread
import os
from signal import pause
import logging

LOG_PATH = os.path.join(os.path.dirname(__file__), 'javi.log')

# Config logging
#logging.basicConfig(filename=LOG_PATH, level=logging.DEBUG)
logging.basicConfig(
     filename=LOG_PATH,
     level=logging.DEBUG, 
     format= '[%(asctime)s] {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s',
     datefmt='%H:%M:%S'
 )

def startprogram(i):
    print("Running thread %d" % i)
    logging.debug("Running thread %d" % i)
    if (i == 0):
        time.sleep(1)
        print('Running: db_local.py')
        logging.debug("Running: db_local.py")
        os.system("sudo python3 /home/pi/Javi/db_local.py")
    elif (i == 1):
        print('Running: fire_sent.py')
        logging.debug("Running: fire_sent.py")
        time.sleep(1)
        os.system("sudo python3 /home/pi/Javi/fire_sent.py")
    else:
        pass

for i in range(2):
    t1 = Thread(target=startprogram, args=(i,))
    t1.daemon = True
    t1.start()
    
pause()