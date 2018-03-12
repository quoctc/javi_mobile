//
//  DatePickerViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 3/10/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePickerFrom: UIDatePicker!
    @IBOutlet weak var datePickerTo: UIDatePicker!
    @IBOutlet weak var filterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Custome UI
        datePickerFrom.setValue(UIColor.yellow, forKeyPath: "textColor")
        datePickerTo.setValue(UIColor.yellow, forKeyPath: "textColor")
        filterButton.layer.borderColor = UIColor.yellow.cgColor
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.cornerRadius = 8.0
        //Custome data
        datePickerFrom.maximumDate = Date()
        datePickerTo.maximumDate = Date()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //User selected from and to date
    @IBAction func didSelectedDate(_ sender: UIDatePicker) {
        if sender == datePickerTo {
            datePickerFrom.maximumDate = datePickerTo.date
        }
    }
    
    //User touched filter button
    @IBAction func touchedDoneBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "SegueDismissToChart", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? MainViewController {
            next.updateFilterDate(fromDate: datePickerFrom.date, toDate: datePickerTo.date)
        }
    }
}
