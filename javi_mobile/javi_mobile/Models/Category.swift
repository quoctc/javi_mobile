//
//  Category.swift
//  EngVid
//
//  Created by MAC on 11/3/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import Foundation

struct Category: Decodable, ArrayDecodable {
    
    var title: String?
    var description: String?
    
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T {
        var category = Category()
        let sourceDictionary = source as! [AnyHashable: Any]
        
        category.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"] as AnyObject?)
        category.description = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["description"] as AnyObject?)
        
        return category as! T
    }
    
    static func ==(lhs:Category, rhs:Category) -> Bool {
        return lhs.title == rhs.title
    }
}
