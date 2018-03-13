//
//  AccountType.swift
//  EngVid
//
//  Created by Quoc Tran on 3/1/18.
//  Copyright © 2018 Quoc Tran. All rights reserved.
//

import Foundation

struct AccountType: Decodable, ArrayDecodable {
    
    var type: String?
    var id: Int64?
    var packageId: String?
    var packagePrice: Double?
    var intro: String?
    var features: [String]?
    
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T! {
        var accountType = AccountType()
        let sourceDictionary = source as! [AnyHashable: Any]
        
        accountType.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
        accountType.type = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?)
        accountType.packageId = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["package_id"] as AnyObject?)
        accountType.intro = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["intro"] as AnyObject?)
        accountType.features = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["features"] as AnyObject?)
        
        return accountType as! T
    }
}
