//
//  Camera.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

open class Camera: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var ipAddress: String = ""
    @objc dynamic var port: String?
    @objc dynamic var userName: String?
    @objc dynamic var passWord: String?
    
    convenience init(name: String,
         ipAddress: String,
         port: String,
         userName: String,
         passWord: String) {
        self.init()
        self.name = name
        self.ipAddress = ipAddress
        self.port = port
        self.userName = userName
        self.passWord = passWord
    }
    
    required public init() {
        super.init()
    }
    
    required public init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required public init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
