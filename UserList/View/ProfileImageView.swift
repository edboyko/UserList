//
//  ProfileImageView.swift
//  UserList
//
//  Created by Edwin Boyko on 06/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = cornerRadius
    }
}
