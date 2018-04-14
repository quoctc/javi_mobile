//
//  SARoundableButton.swift
//  gafs
//
//  Created by Quoc Tran on 3/13/18.
//  Copyright © 2018 Saritasa. All rights reserved.
//

import UIKit

class SARoundableButton: UIButton {

    /// corner Radius
    @IBInspectable
    dynamic open var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    /// is Clips To Bounds
    @IBInspectable
    dynamic open var isClipsToBounds: Bool = true {
        didSet {
            clipsToBounds = isClipsToBounds
        }
    }
    
    /// border Width
    @IBInspectable
    dynamic open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    /// default border Color
    @IBInspectable
    dynamic open var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// disable Border Color
    @IBInspectable
    dynamic open var disableBorderColor: UIColor = UIColor.gray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    /// default Background Color
    @IBInspectable
    dynamic open var defaultBackgroundColor: UIColor?
    
    /// disable Background Color
    @IBInspectable
    dynamic open var disableBackgroundColor: UIColor = UIColor.gray
    
    /// disable opacity
    @IBInspectable
    dynamic open var disableOpacity: Float = 0.5
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let defaultBackgroundColor = self.defaultBackgroundColor {
                    self.backgroundColor = defaultBackgroundColor
                }
                self.layer.borderColor = borderColor.cgColor
                self.layer.opacity = 1.0
            } else {
                self.backgroundColor = disableBackgroundColor
                self.layer.borderColor = disableBorderColor.cgColor
                self.layer.opacity = disableOpacity
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = cornerRadius
        self.isEnabled = true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
