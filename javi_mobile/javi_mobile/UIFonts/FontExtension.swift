//
//  FontExtension.swift
//  streetparking
//
//  Created by Quoc Tran on 1/5/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    static func robotoBold(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.robotoBold.rawValue, size: size)
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.robotoRegular.rawValue, size: size)
    }
    
    static func robotoItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.robotoItalic.rawValue, size: size)
    }
    
    static func robotoLight(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.robotoLight.rawValue, size: size)
    }
    
    static func sfUITextRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: Fonts.sfUITextRegular.rawValue, size: size)
    }
}
