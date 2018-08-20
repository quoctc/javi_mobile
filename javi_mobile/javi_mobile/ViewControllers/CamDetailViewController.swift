//
//  CamDetailViewController.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class CamDetailViewController: UIViewController {

    @IBOutlet weak var ipCamViewer: L3SDKIPCamViewer!
    
    var camera: Camera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initCamera()
    }
    
    private func initCamera() {
//        guard let camera = self.camera else {
//            return
//        }
        camera = Camera(name: "Test", ipAddress: "tcp/h264://192.168.13.51", port: "8000", userName: "", passWord: "")
        
        ////////////////////////////////////////////////////////////////////////
        //IPCAM 1
        //sets remote ipcam params
        let ipCam1 = L3SDKIPCam()
        ipCam1.url = "tcp/h264://192.168.13.51"//camera.ipAddress
        //camera.port = "8000"
        if let port = camera?.port, let intPort = Int(port) {
            ipCam1.port = intPort
        }
        //ipCam1.videoFolder="axis-cgi/mjpg/";
        //ipCam1.videoName="video.cgi";
        
        //start streaming
        //ipCamViewer.delegate = self;
        ipCamViewer.ipCam = ipCam1;
        ipCamViewer.play()
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

extension CamDetailViewController:L3SDKIPCamViewerDelegate {
    func l3SDKIPCamViewer_ConnectionError(_ error: Error!) {
        print(error)
    }
    
    func l3SDKIPCamViewer_AuthenticationRequired(_ ipCam: L3SDKIPCam!, sender: L3SDKIPCamViewer!) {
        
    }
    
    
}
