# javi_mobile

# Mobile Source:
https://github.com/quoctc/javi_mobile.git

## How to open and run the mobile source code:
### Requisites
1. Mac OS # Opration System
2. Xcode 9.3 # IDE
https://itunes.apple.com/vn/app/xcode/id497799835?mt=12
3. Cocoa Pods 1.5.3 # To install libraries
This is instruction how to install cocoa pods:
https://stackoverflow.com/questions/20755044/how-to-install-cocoapods
4. Enroll an Appdle Development program (optional)
If we do not enroll an apple developemt program, we only can run the app on the simulator
https://developer.apple.com/programs/
### Open and run the source code
1. Install libraries
 - Open command line tool in Mac OS. cd to the project folder **javi_mobile**
 For example:
 ```
 sudo cd /Users/mac/Documents/Projects/Home/JavisIot/javi_mobile/javi_mobile
 ```
 - After cd to project folder, type the commanline below to install libraries:
 ```
 pod install
 ```
 
 This is the example result: 
 https://screencast.com/t/Q0cccOrh9
 
2. Open project folder in Mac OS finder, find the project workspace: **javi_mobile.xcworkspace** double click and open the project in Xcode.
https://screencast.com/t/SUJ2pgNbN

This is the example result:
https://screencast.com/t/SUJ2pgNbN

3. How to use Xcode
 An instruction for using Xcode for beginer:
 https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/BuildABasicUI.html
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
- javi_start.py
- javi.service
- system_reboot.py
- javi-9e878-firebase-adminsdk-0l20q-88c15ed3bc.json

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
