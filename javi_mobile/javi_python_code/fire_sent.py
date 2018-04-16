import pyrebase
import sqlite3
import os
import time

# Minutes to sync 
minutes = 0.5

JSON_PATH = os.path.join(os.path.dirname(__file__), 'javi-9e878-firebase-adminsdk-0l20q-88c15ed3bc.json')

#Config for fire base connect
config = {
  "apiKey": "AIzaSyAmegJ16miejiq7692rneO8j--BRRYYHnA",
  "authDomain": "javi-9e878.firebaseapp.com",
  "projectId": "javi-9e878",
  "databaseURL": "https://javi-9e878.firebaseio.com",
  "storageBucket": "javi-9e878.appspot.com",
  "serviceAccount": JSON_PATH,
  "messagingSenderId": "431657355859"
}

firebase = pyrebase.initialize_app(config)

#auth
#auth = firebase.auth()
# Log the user in
#user = auth.sign_in_with_email_and_password("quoctc@gmail.com", "12332100")

# Get a reference to the database service
db = firebase.database()

# Init local database connection
# connect to a database file, if not exist it will create a new one
# create a default path to connect to and create (if necessary) a database
# called 'database.sqlite3' in the same directory as this script
DEFAULT_PATH = os.path.join(os.path.dirname(__file__), 'javi.db')

def db_connect(db_path=DEFAULT_PATH):  
    conn = sqlite3.connect(db_path)
    return conn

# conn = sqlite3.connect('javi.db')
# c = conn.cursor()

# Query from local database
def query():
    conn = db_connect()
    c = conn.cursor()
    c.execute('SELECT * FROM data')
    results = c.fetchall()
    conn.close()
    return results

# Delete from local database
def delete(uuid):
    print("deleting: ",uuid)
    conn = db_connect()
    c = conn.cursor()
    uuids=(uuid,)
    c.execute('DELETE FROM data WHERE uuid = ?', uuids)
    # Save (commit) the changes
    conn.commit()
    conn.close()

def exits(uuid):
    try:
        data = db.child("data").order_by_child("uuid").equal_to(str(uuid)).get() 
        return any(data.val())
    except IndexError as err:
        print(err)
        return False
    
# Sent to firebase database
def send(new_val_sensor):
    print("sending data:", new_val_sensor)
    try: 
        # first - check that this records was available on firebase or not
        if exits(new_val_sensor['uuid']) == False:
            print("not exits - add new")
            # Add new
            db.child("data").push(new_val_sensor)
        print("all done")
        # Todo: delete record in local database
        delete(new_val_sensor['uuid'])
    except Exception as exp:
        print("I found the error: ")
        print(exp)

# Main function
def execute():
    localData = query()
    for record in localData:
        # Create json value
        new_val_sensor = {
            "uuid": record[0],
            "time_stamp": record[1],
            "value":record[2],
            "type":record[3]
        }
        send(new_val_sensor)
    
def main():
    while 1:
        print("executing")
        execute()
        time.sleep(minutes*60)

if __name__ == "__main__":
    main()
    
