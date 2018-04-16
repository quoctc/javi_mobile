import sqlite3
import uuid
import os
import datetime
import time
import serial
import pyrebase
from threading import Thread

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

#Config for fire base connect
config = {
  "apiKey": "AIzaSyAmegJ16miejiq7692rneO8j--BRRYYHnA",
  "authDomain": "javi-9e878.firebaseapp.com",
  "projectId": "javi-9e878",
  "databaseURL": "https://javi-9e878.firebaseio.com",
  "storageBucket": "javi-9e878.appspot.com",
  "serviceAccount": JSON_PATH,
  "messagingSenderId": "431657355859",
  "led_id": "0"
}

firebase = pyrebase.initialize_app(config)
# Get a reference to the database service
firebase_db = firebase.database()

class LED_Control(object):
    def __init__(self):
        print("start LED module control")

    def writeSerial(self, value):
        data = 'A' + value + 'B'
        print("Sending to serial: {}".format(data))
        ser.write(data.encode())

    # Read data from serial port
    def readSerial(self):
        print("reading USB")
        data = ''
        while True:
            #data = input("Please enter USB0: ")
            data = ser.readline().decode('utf-8')
            if len(data) > 0:
                print("received data: {}".format(data.strip().lstrip().rstrip()))
                break
        return data.strip().lstrip().rstrip()    
    
    def switchLED(self, value):
        self.writeSerial(value)
        response = ''
        while response != value:
            response = self.readSerial()
        print("done!!!")
    
    def start(self):
        print("start LED stream")
        def led_stream_handler(data):
            status = data["data"]
            print("LED new value: {}".format(str(status)))
            if bool(status) == True:
                self.switchLED('on')
            elif bool(status) == False:
                self.switchLED('off')
            else:
                print('something is wrong')
        
        led_stream = firebase_db.child("leds").child(config["led_id"]).stream(led_stream_handler)
        while True:
            a = "123"
            # data = input("[{}] Type exit to disconnect: ".format('?'))
#             if data.strip().lower() == 'exit':
#                 print('Stop led stream')
#                 if led_stream:
#                     try:
#                         led_stream.close()
#                     except AttributeError as error:
#                         print("get the error: {}".format(error))
#                 break
    
        
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

# Save data to local database
def save(values):
    conn = db_connect()
    c = conn.cursor()
    
    timeStamp = time.time()
    types = ["a","b","c"]
    i = 0
    records = []
    for value in values:
        intValue = int(value)
        if intValue > 0:
            uuidString = str(uuid.uuid4())
            record = (uuidString, timeStamp, intValue, types[i])
            print(record)
            records.append(record)
        i += 1
        
    print("records: ", records)
    c.executemany('INSERT INTO data VALUES (?,?,?,?)', records)
    conn.commit()
    print("Inserted data", records)

def tracking_function():
    print("start tracking function")
    createTableIfNotExist()
    while True:
        x = ser.readline()
        if len(x) > 3:
            values = x.decode('utf-8').split(";")
            print(values)
            save(values)

def led_function():
    led_control = LED_Control()
    led_control.start()

def main():
    # Start thread for tracking function
    # t1 = Thread(target=tracking_function)
#     t1.daemon = True
#     t1.start()
#
    # Start another thread for led control function
    t2 = Thread(target=led_function)
    t2.daemon = True
    t2.start()
    
    while True:
        a = "test"
  
if __name__== "__main__":
  main()