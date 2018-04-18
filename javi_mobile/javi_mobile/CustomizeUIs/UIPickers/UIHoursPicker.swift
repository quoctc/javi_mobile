//
//  UIHoursPicker.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/14/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class UIHoursPicker: UIPickerView {
    var data = [String]() {
        didSet {
            text = data[0]
            selectedValue = Int(text)
            if data.count > 0 {
                minimumValue = Int(data.first!)!
            }
            self.reloadComponent(0)
        }
    }
    var text = ""
    var minimumValue = 0 {
        didSet {
            self.reloadComponent(0)
            if let last = data.last, let intLast = Int(last), intLast >= minimumValue {
                if selectedValue < minimumValue {
                    self.selectedValue = minimumValue
                    self.selectRow(minimumValue, inComponent: 0, animated: true)
                }
            }
        }
    }
    var didSelectTitleCalback: ((_ title: String)->Void)? = nil
    var selectedValue: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
    }
}

extension UIHoursPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension UIHoursPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = data[row]
        let label = UILabel()
        label.textColor = tintColor
        if Int(title)! < minimumValue {
            label.textColor = .gray
        }
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = title
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard Int(data[row])! >= minimumValue else {
            selectRow(minimumValue, inComponent: 0, animated: true)
            return
        }
        text = data[row]
        selectedValue = Int(data[row])
        didSelectTitleCalback?(text)
    }
}
