//
//  LED.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/11/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation

struct LED: Decodable {
    
    var status: Bool?
    
    // MARK - Protocal
    //decode from json to object
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T {
        var led = LED()
        if let sourceDictionary = source as? [AnyHashable: Any] {
            led.status = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["status"] as AnyObject?)
        }
        return led as! T
    }
}
