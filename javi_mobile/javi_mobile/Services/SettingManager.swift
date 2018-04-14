//
//  SettingManager.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/13/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation

class SettingManager {
    public static let shared = SettingManager()
    
    private (set) var ledId: UInt64? {
        set {
            UserDefaults.standard.set(newValue, forKey: "ledId")
        }
        get {
            return UInt64(UserDefaults.standard.integer(forKey: "ledId"))
        }
    }
    
    private init() { }
    
    func update(ledId: UInt64) {
        self.ledId = ledId
    }
}
