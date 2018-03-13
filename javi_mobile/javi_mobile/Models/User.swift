//
//  User.swift
//  EngVid
//
//  Created by MAC on 11/17/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import Foundation

class Setting: Decodable {
    var language: String?
    var notification: Bool?
    var favoriteTopics: Array<String>?
    var favoriteTeachers: Array<String>?
    var accountTypes: String?
    
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T {
        let setting = Setting()
        let sourceDictionary = source as! [AnyHashable: Any]
        
        setting.language = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["language"] as AnyObject?)
        setting.notification = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["notification"] as AnyObject?)
        setting.favoriteTopics = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["favorite_topics"] as AnyObject?)
        setting.favoriteTeachers = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["favorite_teachers"] as AnyObject?)
        setting.accountTypes = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["account_types"] as AnyObject?)
        
        return setting as! T
    }
    
    func encode() -> [String: Any] {
        return ["account_types": self.accountTypes ?? "Free","language": self.language ?? "en", "notification": self.notification ?? true, "favorite_topics": self.favoriteTopics ?? "", "favorite_teachers": self.favoriteTeachers ?? ""]
    }
}

class User: Decodable, ArrayDecodable {
    var email: String?
    var icon: String?
    var level: String?
    var numberLesson: Array<String>?
    var numberQuiz: Array<String>?
    var settings: Setting?
    
    static func decode<T>(source: AnyObject, instance: AnyObject?) -> T {
        let user = User()
        let sourceDictionary = source as! [AnyHashable: Any]
        
        user.email = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["email"] as AnyObject?)
        user.icon = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["icon"] as AnyObject?)
        user.level = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["level"] as AnyObject?)
        user.numberLesson = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["number_lesson"] as AnyObject?)
        user.numberQuiz = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["number_quiz"] as AnyObject?)
        user.settings = Decoders.decodeOptional(clazz: Setting.self, source: sourceDictionary["settings"] as AnyObject?)
        
        return user as! T
    }
    
    func encode() -> [String: Any] {
        return ["email": self.email ?? "", "icon": self.icon ?? "", "level": self.level ?? "", "numberLesson": self.numberLesson?.joined(separator: ",") ?? "", "numberQuiz": self.numberQuiz?.joined(separator: ",") ?? ""]
    }
}
