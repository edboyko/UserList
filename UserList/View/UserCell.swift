//
//  UserCell.swift
//  UserList
//
//  Created by Edwin Boyko on 04/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet var profileImageView: UIImageView?
    @IBOutlet var displayNameLabel: UILabel?
    @IBOutlet var imageLoadingIndicator: UIActivityIndicatorView!
    
    func configure(with user: PersistentUser) {
        
        self.displayNameLabel?.text = user.displayName
    }
}
