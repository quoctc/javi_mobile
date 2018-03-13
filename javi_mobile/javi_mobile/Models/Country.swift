//
//  Country.swift
//  EngVid
//
//  Created by MAC on 11/20/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import Foundation

struct Country: Decodable, ArrayDecodable {
    
    var name: String?
    var flag: String?
    
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T! {
        var country = Country()
        let sourceDictionary = source as! [AnyHashable: Any]
        
        country.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
        country.flag = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["flag"] as AnyObject?)
        
        return country as! T
    }
}
