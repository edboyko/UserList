//
//  UsersCollectionViewDelegate.swift
//  UserList
//
//  Created by Edwin Boyko on 04/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import UIKit
import CoreData

class UsersCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    private let collectionView: UICollectionView
    
    private let usersProvider: UsersProvider
    private var imageProviders = [Int64 : ImageProvider]()
    
    private(set) var users = [PersistentUser]()
    
    private init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.usersProvider = UsersProvider()
    }
    
    convenience init(with collectionView: UICollectionView) {
        self.init(collectionView: collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func getUsers() {
        usersProvider.getUsers() { [weak self] (users, error) in
            DispatchQueue.main.async {
                
                if let users = users {
                    self?.users.append(contentsOf: users)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        
        let user = users[indexPath.item]
        
        userCell.configure(with: user)
        userCell.profileImageView?.image = nil
        if let imageURL = user.profileImage {
            imageProviders[user.userId] = ImageProvider()
            imageProviders[user.userId]?.getImage(url: imageURL, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    userCell.profileImageView?.image = image
                    userCell.setNeedsLayout()
                    self?.imageProviders.removeValue(forKey: user.userId)
                }
            })
        }
        return userCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingView", for: indexPath) as! LoadingView
        if usersProvider.hasMorePages {
            loadingView.activityIndicator?.startAnimating()
        }
        else {
            loadingView.activityIndicator?.stopAnimating()
        }
        return loadingView
    }
}
extension UsersCollectionViewDataSource: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        collectionView.reloadData()
    }
}
extension UsersCollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if usersProvider.hasMorePages { getUsers() }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        imageProviders[user.userId]?.stopImageDownload()
        imageProviders.removeValue(forKey: user.userId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = UIScreen.main.bounds.width/3
        return CGSize(width: length, height: length)
    }
}
