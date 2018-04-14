//
//  SettingViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/11/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import MBProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var ledTextField: SALabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContentData()
    }

    @IBAction func touchUpdateBtn(_ sender: Any) {
        if let text = ledTextField.text, let value = UInt64(text) {
            let loadingHud = MBProgressHUD.showAdded(to: self.view, animated: true)
            //Check that ledId available on firebase
            LEDService().isAvailable(ledId: value, completionHandler: { (isAvailable) in
                loadingHud.hide(animated: true)
                if isAvailable == true {
                    SettingManager.shared.update(ledId: value)
                } else {
                    self.showSimpleAlert(title: "Lỗi", message: "Led Id này không tồn tại")
                }
            })
        } else {
            self.showSimpleAlert(title: "Lỗi", message: "Bạn phải nhập led id trước khi nhấn update")
        }
    }
    
    @IBAction func touchCreateNewBtn(_ sender: Any) {
        LEDService().generateNewLedId { (ledId) in
            SettingManager.shared.update(ledId: ledId)
            self.ledTextField.text = String(ledId)
        }
    }
    
    private func loadContentData() {
        ledTextField.text = (SettingManager.shared.ledId != nil ? String(SettingManager.shared.ledId ?? 0) : "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .SegueSettingBackToMain:
            if let next = segue.destination as? MainViewController {
                next.updateContentData()
            }
        default:
            break
        }
    }

}
