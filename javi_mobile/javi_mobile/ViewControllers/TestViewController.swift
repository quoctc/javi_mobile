//
//  TestViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/14/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let pickerVC = UIStoryboard.main().instantiate(viewController: .PickerViewController)
        //fromTextField.inputView = pickerVC.view
        //toTextField.inputView = pickerVC.view
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
