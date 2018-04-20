# javi_mobile

# Mobile Source:
https://github.com/quoctc/javi_mobile.git

# Raspberry Pi Source:
https://github.com/quoctc/javi_mobile/tree/develop/javi_mobile/javi_python_code

##  Setup for Raspberry Pi 3
### Step 1: Install library
1. Install firebase library
Open Terminal and type:
```
sudo pip3 install pyrebase
```
### Step 2: Copy python source code files
- db_local.py
- fire_sent.py
- javi.service
- javi-9e878-firebase-adminsdk-0l20q-88c15ed3bc.json
- javi_start.py

### Step 2: System service config
1. Open Terminal and type these cmd lines
```
sudo cp /home/pi/Javi/javi.service /etc/systemd/system/javi.service
sudo systemctl start javi.service
```
## Change settings in Raspberry Pi 3
1. Change time rate to update to firebase (unit is minutes)
Open fire_sent.py and edit this line:
```
# Minutes to sync
minutes = 0.5
```
2. Controling another Led Id
Open db_local.py and edit *led_id* inside this config:
```
#Config for fire base connect
config = {
"apiKey":
"authDomain":
"projectId":
"databaseURL":
"storageBucket":
"serviceAccount": JSON_PATH,
"messagingSenderId": 
"led_id": "0",
"tries_count": 5
}
```
