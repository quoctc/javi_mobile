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
//    @IBOutlet weak var fromHoursTextField: UITextField!
//    @IBOutlet weak var toHoursTextField: UITextField!
    
    @IBOutlet weak var fromHoursPicker: UIHoursPicker!
    @IBOutlet weak var toHoursPicker: UIHoursPicker!
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initPickers()
    }
    
    private func initPickers() {
        var data = [String]()
        for i in 0...23 {
            data.append(String(i))
        }
        fromHoursPicker.data = data.filter({ (item) -> Bool in
            return item != data.last
        })
        toHoursPicker.data = data
        
        toHoursPicker.minimumValue = fromHoursPicker.selectedValue + 1
        
        fromHoursPicker.didSelectTitleCalback = { [weak self] (_ title: String) in
            self?.toHoursPicker.minimumValue = (self?.fromHoursPicker.selectedValue ?? 0) + 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //User touched filter button
    @IBAction func touchedDoneBtn(_ sender: Any) {
        guard let fromHours = fromHoursPicker.selectedValue,
            fromHours >= 0,
            let toHours = toHoursPicker.selectedValue,
            toHours <= 23,
            toHours > fromHours else { return }
        self.fromHours = fromHours
        self.toHours = toHours
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

