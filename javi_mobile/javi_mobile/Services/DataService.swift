//
//  DataService.swift
//  EngVid
//
//  Created by MAC on 10/23/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol Gettable {
    associatedtype T
    func get(completionHandler: @escaping (Result<[T]>) -> Void)
    func getObjWithKey(key: String, value: String, completionHandler: @escaping (Result<T>) -> Void)
}

protocol Settable {
    associatedtype T
    func setObjectForKey(key: String, value: Any, completionHandler: @escaping (Result<T>) -> Void)
    func setObjectsForKeys(keyedValues: [String: Any], completionHandler: @escaping (Result<T>) -> Void)
}

enum APIError: Error {
    case normal
    case noConnected
}

enum Result<T> {
    case Success(T)
    case Failure(Error)
}

struct DataService: Gettable {
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference().child("data")
    }
    
    //Get values from firebase
    func get(completionHandler: @escaping (Result<[Sensor]>) -> Void) {
        ref.observe(.value, with: { (snapshot) in
            if let sensors = snapshot.value as? NSArray {
                completionHandler(Result.Success(Sensor.decodeArrayOf(source: sensors)))
            }
            else {
                completionHandler(Result.Success([Sensor]()))
            }
        }) { (error) in
            completionHandler(Result.Failure(error))
        }
    }
    
    //Get values from firebase from date to date
    func get(startDate: Date, endDate: Date, completionHandler: @escaping (Result<[Sensor]>) -> Void) {
        let startDateTimeStamp = startDate.timeIntervalSince1970
        let endDateTimeStamp = endDate.timeIntervalSince1970
        print(startDateTimeStamp)
        print(endDateTimeStamp)
        //1457423649 - 1520495650 worked
//        let connectedRef = Database.database().reference(withPath: ".info/connected")
//        connectedRef.observe(.value, with: { snapshot in
//            if let connected = snapshot.value as? Bool, connected == true {
                self.ref.queryOrdered(byChild: "time_stamp").queryStarting(atValue: startDateTimeStamp).queryEnding(atValue: endDateTimeStamp).observe(.value) { (snapshot) in
                    if let sensorDataArray = snapshot.value as? NSArray {
                        let noneNullArray = sensorDataArray.filter({ (item) -> Bool in
                            return !(item is NSNull)
                        })
                        completionHandler(Result.Success(Sensor.decodeArrayOf(source: noneNullArray)))
                    }
                    else if let sensorDataDict = snapshot.value as? NSDictionary {
                        let noneNullArray = sensorDataDict.allValues.filter({ (item) -> Bool in
                            return !(item is NSNull)
                        })
                        completionHandler(Result.Success(Sensor.decodeArrayOf(source: noneNullArray)))
                    }
                    else {
                        completionHandler(Result.Success([Sensor]()))
                    }
                }
//            } else {
//                print("Not connected")
//                completionHandler(Result.Failure(APIError.noConnected))
//            }
//        })
    }
    
    //Get values from firebase with specific key
    func getObjWithKey(key: String, value: String, completionHandler: @escaping (Result<Sensor>) -> Void) {
        ref.queryOrdered(byChild: key).queryEqual(toValue: value).observe(.value, with: { (snapshot) in
            if let sensorDict = snapshot.value as? NSDictionary {
                completionHandler(Result.Success(Sensor.decode(source: sensorDict.allValues.first as AnyObject, instance: nil)))
            }
            else {
                completionHandler(Result.Success(Sensor()))
            }
        }) { (error) in
            completionHandler(Result.Failure(error))
        }
    }
}
