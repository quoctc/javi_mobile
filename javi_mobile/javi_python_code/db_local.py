import sqlite3
import uuid
import os
import datetime
import time
import serial
import pyrebase
from threading import Thread
from signal import pause
import logging

led_input = []
led_output = []

#Serial Config
ser = serial.Serial(
    port = '/dev/ttyUSB0',
    baudrate = 9600,
    parity = serial.PARITY_NONE,
    stopbits = serial.STOPBITS_ONE,
    bytesize = serial.EIGHTBITS,
    timeout=1
)

JSON_PATH = os.path.join(os.path.dirname(__file__), 'javi-9e878-firebase-adminsdk-0l20q-88c15ed3bc.json')
LOG_PATH = os.path.join(os.path.dirname(__file__), 'javi.log')

#Config for fire base connect
config = {
  "apiKey": "AIzaSyAmegJ16miejiq7692rneO8j--BRRYYHnA",
  "authDomain": "javi-9e878.firebaseapp.com",
  "projectId": "javi-9e878",
  "databaseURL": "https://javi-9e878.firebaseio.com",
  "storageBucket": "javi-9e878.appspot.com",
  "serviceAccount": JSON_PATH,
  "messagingSenderId": "431657355859",
  "led_id": "0",
  "tries_count": 5
}

# Config logging
#logging.basicConfig(filename=LOG_PATH, level=logging.DEBUG)
logging.basicConfig(
     filename=LOG_PATH,
     level=logging.DEBUG, 
     format= '[%(asctime)s] {%(pathname)s:%(lineno)d} %(levelname)s - %(message)s',
     datefmt='%H:%M:%S'
 )


firebase = pyrebase.initialize_app(config)
# Get a reference to the database service
firebase_db = firebase.database()

class LED_Control(object):
    def __init__(self):
        print("start LED module control")
        logging.debug("start LED module control")

    def writeSerial(self, value):
        global led_output
        data = 'A' + 'L' + value + 'B'
        print("Sending to serial: {}".format(data))
        logging.debug("Sending to serial: %s", data)
        led_output.append(data)

    # Read data from serial port
    def readSerial(self):
        global led_input
        print("reading USB")
        #logging.debug("reading USB")
        data = ''
        if len(led_input) > 0:
            data = led_input[-1]
            led_input = led_input[:-1] #clear read data
            print("received data: {}".format(data))
            logging.debug("received data: %s", data)
        return data    
    
    def clearAll(self):
        global led_input
        global led_output
        led_input.clear()
        led_output.clear()
    
    def switchLED(self, value):
        self.writeSerial(value)
        response = ''        
        #2 tracking time
        startTime = datetime.datetime.now()
        triesCount = 0
        while response[1:] != value: # 1 mean remove L from response
            response = self.readSerial()
            print("response: {}; value: {}\n".format(response[1:], value))
            #logging.debug("response: %s; value: %s\n", response[1:], value)
            currentTime = datetime.datetime.now()
            date = currentTime - startTime
            if date.seconds >= 1:
                print("switch led again with value: {}".format(value))
                logging.debug("switch led again with value: %s", value)
                triesCount += 1
                self.writeSerial(value)
                startTime = datetime.datetime.now()
            if triesCount >= config["tries_count"]:
                print("Error connection, Do not try again")
                logging.debug("Error connection, Do not try again")
                self.clearAll()
                break
                
        print("done!!!")
        logging.debug("done!!!")
    
    def start(self):
        print("start LED stream")
        logging.debug("start LED stream")
        def led_stream_handler(data):
            status = data["data"]
            print("LED new value: {}".format(str(status)))
            logging.debug("LED new value: %s",str(status))
            if bool(status) == True:
                self.switchLED(str(config["led_id"] + 'on'))
            elif bool(status) == False:
                self.switchLED(str(config["led_id"] + 'off'))
            else:
                print("something is wrong")
                logging.debug("something is wrong")
        
        led_stream = firebase_db.child("leds").child(config["led_id"]).child("status").stream(led_stream_handler)
        #pause()
        
# Init local database connection
# connect to a database file, if not exist it will create a new one
# create a default path to connect to and create (if necessary) a database
# called 'database.sqlite3' in the same directory as this script
DEFAULT_PATH = os.path.join(os.path.dirname(__file__), 'javi.db')

def db_connect(db_path=DEFAULT_PATH):  
    conn = sqlite3.connect(db_path)
    return conn

def createTableIfNotExist():
    conn = db_connect()
    c = conn.cursor()
    # Create table
    c.execute('''CREATE TABLE IF NOT EXISTS data
                 (uuid text PRIMARY KEY, time_stamp double NOT NULL, value int NOT NULL, type text NOT NULL)''')
    # Save (commit) the changes
    conn.commit()
    

# connect to a database file, if not exist it will create a new one
# We can also close the connection if we are done with it.
# Just be sure any changes have been committed or they will be lost.
#conn.close()

def convert_to_int_arr(values):
    results = []
    for value in values:
        try:
            value = int(value)
            results.append(value)
        except ValueError as error:
            print(error)
            results.clear()
            break;
    return results
            
# Save data to local database
def save(values):
    converted_values = convert_to_int_arr(values)
    if len(converted_values) == 0:
        return
    conn = db_connect()
    c = conn.cursor()
    
    timeStamp = time.time()
    types = ["a","b","c"]
    i = 0
    records = []
    
    for value in converted_values:
        intValue = 0
        if value:
            intValue = int(value)
        if intValue > 0:
            uuidString = str(uuid.uuid4())
            record = (uuidString, timeStamp, intValue, types[i])
            print(record)
            records.append(record)
        i += 1
        
    print("records: ", records)
    logging.debug("records: %s", records)
    c.executemany('INSERT INTO data VALUES (?,?,?,?)', records)
    conn.commit()
    print("Inserted data", records)
    logging.debug("Inserted data", records)

def tracking_function():
    global led_input
    global led_output
    print("start tracking function; ")
    logging.debug("start tracking function; ")
    createTableIfNotExist()
    while True:
        x = ser.readline()
        if len(x) > 3:
            data = x.decode('utf-8').strip().lstrip().rstrip()
            print("data: {}".format(data))
            logging.debug("data: %s",data)
            if data[:1] == 'L':
                led_input.append(data)
                print("Led receiced status")
                logging.debug("Led receiced status")
            else:
                values = data.split(";")
                print(values)
                logging.debug("values: %s", values)
                if len(values) == 3:
                    save(values)
        if len(led_output) > 0:
            print(led_output[-1])
            logging.debug("Led output: %s", led_output[-1])
            ser.write(led_output[-1].encode())
            led_output = led_output[:-1]
        

def led_function():
    led_control = LED_Control()
    led_control.start()

def main():
    # Start thread for tracking function
    t1 = Thread(target=tracking_function)
    t1.daemon = True
    t1.start()

    # Start another thread for led control function
    t2 = Thread(target=led_function)
    t2.daemon = True
    t2.start()
    
    pause() #loop forever
  
if __name__== "__main__":
  main()