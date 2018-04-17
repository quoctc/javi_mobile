//
//  UIViewExtension.swift
//  streetparking
//
//  Created by Quoc Tran on 1/9/18.
//  Copyright © 2018 Saritasa. All rights reserved.
//

import Foundation
import UIKit

//1. Reusable view protocol for the cells
//Create ReusableView protocal
protocol ReusableView: class {}

//ReusableView just use for UIView
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//Make all UITableViewCell is ReusableView
extension UITableViewCell: ReusableView { }

extension UITableViewHeaderFooterView: ReusableView { }

//Make all UICollectionViewCell is ReusableView
extension UICollectionViewCell: ReusableView { }

//2. Nib load protocol for UIView
//Create Nib load protocal
protocol NibLoadableView: class {}

//NibLoadableView just use for UIView
extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

//3.
extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            //fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return T(style: .default, reuseIdentifier: T.reuseIdentifier)
        }
        return cell
    }
    
    func registerForHeaderAndFooter<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibLoadableView {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        register(Nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableHeaderAndFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            //fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            return T(reuseIdentifier: T.reuseIdentifier)
        }
        return view
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: NibLoadableView {
        let Nib = UINib(nibName: T.nibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            //fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
            let cell = T()
            return cell
        }
        return cell
    }
}

extension UIButton {
    /// Helper method to set space between image and title of a button
    ///
    /// - Parameter spacing: distance between image and title
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}
