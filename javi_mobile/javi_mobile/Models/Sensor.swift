//
//  Sensor.swift
//  EngVid
//
//  Created by Quoc Tran on 9/25/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import UIKit

struct Sensor: Decodable, ArrayDecodable {
    
    var timeStamp: Int64?
    var value: Int?
    var type: String?
    
    // MARK - Protocal
    //decode from json to object
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T {
        var sensor = Sensor()
        if let sourceDictionary = source as? [AnyHashable: Any] {
            sensor.timeStamp = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["time_stamp"] as AnyObject?)
            sensor.value = Decoders.decodeOptional(clazz: Int.self, source: sourceDictionary["value"] as AnyObject?)
            sensor.type = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?)
        }
        return sensor as! T
    }
}
