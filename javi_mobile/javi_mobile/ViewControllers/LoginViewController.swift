//
//  LoginViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 3/9/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.perform(segue: .SegueLoginToMain, sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Init sub views of the controller
    func initSubViews() {
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.primary.cgColor
        emailTextField.layer.cornerRadius = 8.0
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.primary.cgColor
        passwordTextField.layer.cornerRadius = 8.0
    }
 
    @IBAction func skipLoginTouched(sender: UIButton) {
        let loadingHud = MBProgressHUD.showAdded(to: self.view, animated: false)
        Auth.auth().signIn(withEmail: "quoctc@gmail.com", password: "12332100") { [weak self] (user, error) in
            self?.getData(fromService: DataService(), completion: { data in
                print("total data: \(data?.count ?? 0)")
                loadingHud.hide(animated: false)
                if error == nil {
                    self?.perform(segue: .SegueLoginToMain, sender: nil)
                }
                else {
                    self?.showSimpleAlert(title: "Error", message: error?.localizedDescription, handler: nil)
                }
            })
        }
    }
    
    private func getData(fromService service: DataService, completion: @escaping (_ data: [Sensor]?)->Void) {
        let loadingHud = MBProgressHUD.showAdded(to: self.view, animated: false)
        print("get all date")
        service.get { [weak self] (result) in
            loadingHud.hide(animated: true)
            switch result {
             case .Success( let data ):
                completion(data)
            case .Failure( let error ):
                self?.showSimpleAlert(title: "Error", message: error.localizedDescription, handler: nil)
                completion(nil)
            }
        }
    }
}

