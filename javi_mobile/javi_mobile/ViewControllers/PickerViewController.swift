//
//  PickerViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/14/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

protocol PickerViewControllerDelegate: NSObjectProtocol {
    func didInput(view: UIView, text: String)
}

class PickerViewController: UIViewController {
    
    @IBOutlet weak var hoursPicker: UIHoursPicker!
    @IBOutlet weak var timerFormatPicker: UITimeFormatPicker!
    
    var selectedText = "" {
        didSet {
            delegate?.didInput(view: self.view, text: selectedText)
        }
    }
    
    weak var delegate: PickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data = [String]()
        for i in 0...11 {
            data.append(String(i))
        }
        hoursPicker.data = data
        
        hoursPicker.didSelectTitleCalback = { [weak self] (title) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.selectedText = "\(strongSelf.hoursPicker.text) \(strongSelf.timerFormatPicker.text)"
        }
        timerFormatPicker.didSelectTitleCalback = { [weak self] (title) in
            guard let strongSelf = self else {
                return
            }
            if title == "PM" {
                strongSelf.hoursPicker.minimumValue = 1
            } else {
                strongSelf.hoursPicker.minimumValue = 0
            }
            strongSelf.selectedText = "\(strongSelf.hoursPicker.text) \(strongSelf.timerFormatPicker.text)"
        }
        selectedText = "\(self.hoursPicker.text) \(self.timerFormatPicker.text)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
