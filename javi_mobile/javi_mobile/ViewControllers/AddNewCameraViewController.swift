//
//  AddNewCameraViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class AddNewCameraViewController: UIViewController {

    @IBOutlet weak var ipAddressTextField: SALabelTextField!
    @IBOutlet weak var portTextField: SALabelTextField!
    @IBOutlet weak var userNameTextField: SALabelTextField!
    @IBOutlet weak var passwordTextField: SALabelTextField!
    @IBOutlet weak var deviceNameTextField: SALabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchSubmitBtn(_ sender: Any) {
        guard let address = ipAddressTextField.text else { return }
        let camera = Camera()
        camera.name = deviceNameTextField.text
        camera.ipAddress = address
        camera.port = portTextField.text
        camera.userName = userNameTextField.text
        camera.passWord = passwordTextField.text
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(camera)
        }
        
        self.dismiss(animated: true, completion: nil)
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
