//
//  Extensions.swift
//  streetparking
//
//  Created by Quoc Tran on 1/5/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension UIColor {
    
    
    /// To Suppot init color with red, green and blue
    ///
    /// - Parameters:
    ///   - red: red number
    ///   - green: green number
    ///   - blue: blue number
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    
    /// To support hex init
    ///
    /// - Parameter rgb: a hex string
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    
    /// Support init color with defined Colors in Constants class
    ///
    /// - Parameter color: color in Constants class
    convenience init(color: Colors, alpha: CGFloat = 1.0) {
        self.init(
            red: (color.rawValue >> 16) & 0xFF,
            green: (color.rawValue >> 8) & 0xFF,
            blue: color.rawValue & 0xFF,
            alpha: alpha
        )
    }
}

extension UILabel {
    var isTruncated: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func scaleImage(newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    func getImageData() -> Data? {
        var data = UIImagePNGRepresentation(self)
        if data == nil {
            data = UIImageJPEGRepresentation(self, 1.0)
        }
        return data
    }
    
    func image(byAddingToCenter text: String) -> UIImage? {
        let textColor = UIColor.white
        let textFont = UIFont.robotoBold(size: 18)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        //For horizontal center
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center    //Just horizontal
        
        //For vertical center
        let textHeight = textFont.lineHeight
        let textY = (self.size.height - textHeight)/2
        let textRect = CGRect(x: 0, y: textY, width: self.size.width, height: textHeight)
        
        //Attributes
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            NSAttributedStringKey.paragraphStyle: textStyle
            ] as [NSAttributedStringKey : Any]
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        //Draw
        text.draw(in: textRect, withAttributes: textFontAttributes)

        //Get image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIViewController {
    func showSimpleAlert(title: String?, message: String?, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            handler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmAlert(title: String, message: String, titleButtonCancel: String, titleButtonOk: String, handlerCancel: (() -> Void)?, handlerOK: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleButtonOk, style: .destructive, handler: { (_) in
            if handlerOK != nil {
                handlerOK!()
            }
        }))
        
        alert.addAction(UIAlertAction(title: titleButtonCancel, style: .default, handler: { (_) in
            if handlerCancel != nil {
                handlerCancel!()
            }
            else {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
