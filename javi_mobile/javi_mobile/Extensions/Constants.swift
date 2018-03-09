//
//  Constants.swift
//  streetparking
//
//  Created by Quoc Tran on 1/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation
import UIKit

/*
 Colors with hex number
 */
enum Colors: Int {
    case colorPrimary = 0xFFFF00
    case colorAuthPrimary = 0x1169D3
    case colorPrimaryLight = 0x3698FF
    case colorLightrayText = 0x9B9B9B
    case colorAlertNormalButton = 0x007AFF
    case colorAlertHightLightButton = 0xFC5A5A
    case colorSearchBorderColor = 0x3D9AFC
    
    case colorMsgSendButtonBg = 0x858E99
    case colorMsgTextBg = 0xFAFAFA
    case colorMsgTextBgDisable = 0xE4E4E4
    case colorMsgBorderText = 0xC7C7CC
    case colorMsgSender = 0x157EFC
    case colorMsgReceiver = 0xF2F2F2
    case colorMsgText = 0x3A3838
}

extension UIColor {
    static let primary = UIColor(color: Colors.colorPrimary)
    static let primaryLight = UIColor(color: Colors.colorPrimaryLight)
    static let dimBackground = UIColor(white: 0, alpha: 0.5)
}

/*
 Fonts defined in Infor.plist
 */
enum Fonts: String {
    case robotoBold = "Roboto-Bold"
    case robotoRegular = "Roboto-Regular"
    case robotoItalic = "Roboto-Italic"
    case robotoLight = "Roboto-Light"
    case sfUITextRegular = "SF-UI-Text-Regular"
}

//Key handler for plist keys
protocol InfoKeyHandler {
    associatedtype KeyIdentifier: RawRepresentable
}

extension InfoKeyHandler where Self: Constants {
    static func infoForKey(_ key: KeyIdentifier) -> String? {
        return Constants.infoForKey(key.rawValue)
    }
}

extension Constants: InfoKeyHandler {
    enum KeyIdentifier: String {
        case SP_API_URL
        case SP_APP_ITUNES_URL
        case MAP_API_KEY
        case PUSHER_APP_KEY
        case PUSHER_CLUSTER
    }
}

class Constants {
    
    // default limitted length for textfield
    static let textLengthLimitDefault = 100
    // default limitted length for textview
    static let longTextLengthLimitDefault = 500
    // default limitted height for rules label.
    static let rulesContentMinLines = 2
    /// To support get values in Infor.plist with key
    ///
    /// - Parameter key: key of value that we want to get
    /// - Returns: value of key that we gived
    class func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}
