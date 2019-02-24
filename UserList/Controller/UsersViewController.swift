//
//  ViewController.swift
//  UserList
//
//  Created by Edwin Boyko on 04/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet private(set) var collectionView: UICollectionView!
    
    var usersDataSource: UsersCollectionViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersDataSource = UsersCollectionViewDataSource(with: collectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == UserDetailsViewController.segueIdentifier {
            guard let cell = sender as? UICollectionViewCell,
                let indexPath = collectionView.indexPath(for: cell),
                let userDetailsViewController = segue.destination as? UserDetailsViewController else {
                return
            }
            
            let user = self.usersDataSource?.users[indexPath.item]
            userDetailsViewController.user = user
            
        }
    }
}

