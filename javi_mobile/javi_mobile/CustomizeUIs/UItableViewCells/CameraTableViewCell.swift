//
//  CameraTableViewCell.swift
//  javi_mobile
//
//  Created by Quoc Tran on 4/15/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class CameraTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var camera: Camera? = nil {
        didSet {
            if let camera = camera {
                self.titleLabel.text = camera.name ?? camera.ipAddress
                self.detailLabel.text = camera.ipAddress
                if let port = camera.port {
                    self.detailLabel.text = "\(detailLabel.text ?? ""):\(port)"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CameraTableViewCell: NibLoadableView { }
