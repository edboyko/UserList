//
//  UsersListViewControllerTests.swift
//  UserListTests
//
//  Created by Edwin Boyko on 24/02/2019.
//  Copyright © 2019 Edwin Boyko. All rights reserved.
//

import XCTest
@testable import UserList

class UsersListViewControllerTests: XCTestCase {
    
    var usersVC: UsersViewController?
    
    override func setUp() {
        let navigationController = UIStoryboard(name: "Main", bundle: Bundle(for: UsersViewController.self)).instantiateInitialViewController() as? UINavigationController
        usersVC = navigationController?.viewControllers.first as? UsersViewController
        
        usersVC?.loadViewIfNeeded()
    }

    override func tearDown() {
        usersVC = nil
    }

    func testUsersViewControllerHasCollectionView() {
        
        XCTAssertNotNil(usersVC?.collectionView)
    }
    
    func testDataSourceIsCorrect() {
        
        XCTAssertTrue(usersVC?.collectionView.dataSource is UsersCollectionViewDataSource)
    }

}
