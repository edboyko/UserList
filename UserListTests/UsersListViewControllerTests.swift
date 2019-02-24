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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsersViewControllerHasCollectionView() {
        
        usersVC?.loadViewIfNeeded()
        
        XCTAssertNotNil(usersVC?.collectionView)
    }

}
