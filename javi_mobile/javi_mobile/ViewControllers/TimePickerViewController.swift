//
//  TimePickerViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/14/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var fromHoursTextField: UITextField!
    @IBOutlet weak var toHoursTextField: UITextField!
    
    var fromHours: Int!
    var toHours: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.yellow, forKeyPath: "textColor")
        filterButton.layer.borderColor = UIColor.yellow.cgColor
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.cornerRadius = 8.0
        //Custome data
        datePicker.maximumDate = Date()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //User touched filter button
    @IBAction func touchedDoneBtn(_ sender: Any) {
        guard let fromHours = fromHoursTextField.text,
            let intFromHours = Int(fromHours), intFromHours >= 0,
            let toHours = toHoursTextField.text,
            let intToHours = Int(toHours), intToHours <= 23 else { return }
        self.fromHours = intFromHours
        self.toHours = intToHours
        self.perform(segue: .SegueDismissToChart, sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .SegueDismissToChart:
            if let next = segue.destination as? MainViewController {
                next.updateFilterHours(date: datePicker.date, fromHours: self.fromHours, toHours: self.toHours)
            }
        }
    }

}
