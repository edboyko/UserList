//
//  UserDetailsViewController.swift
//  UserList
//
//  Created by Edwin Boyko on 06/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet private var profileImageView: UIImageView?
    @IBOutlet private var displayNameLabel: UILabel?
    @IBOutlet private var reputationLabel: UILabel?
    @IBOutlet private var userIdLabel: UILabel?
    @IBOutlet private var registeredDateLabel: UILabel?
    
    var user: PersistentUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayUserInfo()
    }
    
    private func displayUserInfo() {
        guard let user = user else {
            return
        }
        displayNameLabel?.text = user.displayName
        reputationLabel?.text = "Reputation: \(NSNumber(value: user.reputation).stringValue)"
        userIdLabel?.text = "User ID: \(NSNumber(value: user.userId).stringValue)"
        
        registeredDateLabel?.text = user.creationDateString
        if let imageURL = user.profileImage {
            
            ImageProvider().getImage(url: imageURL) { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.profileImageView?.image = image
                }
            }
        }
    }
    
}
