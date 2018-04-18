//
//  UITimeFormatPicker.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/14/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class UITimeFormatPicker: UIPickerView {
    
    var data = ["AM", "PM"]
    var didSelectTitleCalback: ((_ title: String)->Void)? = nil
    var text = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        text = data[0]
    }
}

extension UITimeFormatPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension UITimeFormatPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = data[row]
        let label = UILabel()
        label.textColor = tintColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = title
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = data[row]
        didSelectTitleCalback?(text)
    }
}

