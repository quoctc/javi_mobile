//
//  GrammarLesson.swift
//  EngVid
//
//  Created by MAC on 12/10/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import Foundation

struct GrammarLesson: Decodable, ArrayDecodable {
    
    var title: String?
    var link: String?
    var unit: Int?
    
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T! {
        var grammarLesson = GrammarLesson()
        let sourceDictionary = source as! [AnyHashable: Any]
        
        grammarLesson.title = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["title"] as AnyObject?)
        grammarLesson.link = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["link"] as AnyObject?)
        grammarLesson.unit = Decoders.decodeOptional(clazz: Int.self, source: sourceDictionary["unit"] as AnyObject?)
        
        return grammarLesson as! T
    }
}
