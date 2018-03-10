//
//  StoryboardExtension.swift
//  POPExample
//
//  Created by Quoc Tran on 10/18/17.
//  Copyright © 2017 Quoc Tran. All rights reserved.
//

import UIKit

protocol StoryboardHandler {
    associatedtype StoryboardIdentifier: RawRepresentable
}


// MARK: - View Controllers From Storyboard
extension StoryboardHandler where Self:UIStoryboard {
    func instantiate(viewController identifier: StoryboardIdentifier) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}


// MARK: - Storyboard Identifier (Have to set in .storyboard file and coppy to here
extension UIStoryboard: StoryboardHandler {
    enum StoryboardIdentifier: String {
        case SignupViewController
        case LoginNavigationController
        case IndicatorViewController
        case AlertViewController
        case MapViewController
        case MenuViewController
        case ChatNavigationController
    }
}


// MARK: - Storyboards getters
extension UIStoryboard {
    
    /// Get Auth storyboard
    ///
    /// - Returns: auth storyboard
    class func auth() -> UIStoryboard {
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        return authStoryboard
    }
    
    
    /// Get Main storyboard
    ///
    /// - Returns: main storyboard
    class func main() -> UIStoryboard {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard
    }
    
    /// Get Profile storyboard
    ///
    /// - Returns: profile storyboard
    class func profile() -> UIStoryboard {
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        return profileStoryboard
    }
    
    /// Get Chat storyboard
    ///
    /// - Returns: chat storyboard
    class func chat() -> UIStoryboard {
        let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
        return chatStoryboard
    }
    
    /// Get Shared storyboard
    ///
    /// - Returns: shared storyboard
    class func shared() -> UIStoryboard {
        let mainStoryboard = UIStoryboard(name: "Shared", bundle: nil)
        return mainStoryboard
    }
    
    /// Get initial view controller of the storyboard
    func initialViewController() -> UIViewController {
        if let initialViewController = self.instantiateInitialViewController() {
            return initialViewController
        }
        else {
            return UIViewController()
        }
    }
}
