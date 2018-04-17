//
//  CamListViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import RealmSwift

class CamListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var realm : Realm!
    var cameraList: Results<Camera> {
        get {
            return realm.objects(Camera.self)
        }
    }
    
    var selectedCamera: Camera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        tableView.register(CameraTableViewCell.self)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .SegueCameraListToDetail:
            if let next = segue.destination as? CamDetailViewController {
                next.camera = selectedCamera
            }
        default:
            break
        }
    }
}

extension CamListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cameraList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CameraTableViewCell
        
        let camera = cameraList[indexPath.row]
        cell.camera = camera
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCamera = cameraList[indexPath.row]
        self.perform(segue: .SegueCameraListToDetail, sender: nil)
    }
}
