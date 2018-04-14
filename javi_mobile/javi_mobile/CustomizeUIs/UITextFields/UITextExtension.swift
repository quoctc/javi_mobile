//
//  UITextExtension.swift
//  streetparking
//
//  Created by Quoc Tran on 1/14/18.
//  Copyright © 2018 Saritasa. All rights reserved.
//

import Foundation
import UIKit

protocol Validatable {
    func isValid(allowEmpty: Bool) -> Bool
    func notifyInvalid()
    func reset()
}
