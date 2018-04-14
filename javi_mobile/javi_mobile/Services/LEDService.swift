//
//  LEDService.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/11/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LEDService: Gettable {
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference().child("leds")
    }
    
    //Get values from firebase with specific key
    func get(completionHandler: @escaping (Result<[LED]>) -> Void) {
        //TO DO: not handle yet
    }
    
    func getLEDStatus(ledId: String, completionHandler: @escaping (Result<LED>) -> Void) {
        ref.child(ledId).observe(.value) { (snapshot) in
            if let ledDict = snapshot.value as? NSDictionary {
                completionHandler(Result.Success(LED.decode(source: ledDict as AnyObject, instance: nil)))
            }
            else {
                completionHandler(Result.Failure(APIError.notFound))
            }
        }
//        ref.queryOrdered(byChild: ledId).observe(.value) { (snapshot) in
//            if let ledArray = snapshot.value as? NSArray {
//                completionHandler(Result.Success(LED.decode(source: ledArray.first as AnyObject, instance: nil)))
//            }
//            else {
//                completionHandler(Result.Failure(APIError.notFound))
//            }
//        }
    }
    
    func setLEDStatus(ledId: String, value: Bool, completionHandler: @escaping (Result<LED>) -> Void) {
        ref.child(ledId).updateChildValues(["status" : value == true ? 1 : 0]) { (error, dataRef) in
            if let error = error {
                completionHandler(Result.Failure(error))
            } else {
                let led = LED(status: value)
                completionHandler(Result.Success(led))
            }
        }
    }
    
    func isAvailable(ledId: UInt64, completionHandler: @escaping (Bool) -> Void) {
        ref.child(String(ledId)).observeSingleEvent(of: .value) { (snapshot) in
            completionHandler(snapshot.exists())
        }
    }
    
    func generateNewLedId(completionHandler: @escaping (_ ledId: UInt64) -> Void) {
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let lastId = snapshot.childrenCount
            let newChild = self.ref.child("\(lastId)")
            let newStatusForChild = newChild.child("status")
            newStatusForChild.setValue(0)
            completionHandler(UInt64(lastId))
        }
    }
    
    //Get values from firebase with specific key
    func getObjWithKey(key: String, value: String, completionHandler: @escaping (Result<LED>) -> Void) {
        ref.queryOrdered(byChild: key).queryEqual(toValue: value).observe(.value, with: { (snapshot) in
            if let ledDict = snapshot.value as? NSDictionary {
                completionHandler(Result.Success(LED.decode(source: ledDict.allValues.first as AnyObject, instance: nil)))
            }
            else {
                completionHandler(Result.Success(LED()))
            }
        }) { (error) in
            completionHandler(Result.Failure(error))
        }
    }
}
