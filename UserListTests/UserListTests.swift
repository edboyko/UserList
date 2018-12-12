//
//  UserListTests.swift
//  UserListTests
//
//  Created by Edwin Boyko on 12/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import XCTest
import CoreData
@testable import UserList

class UserListTests: XCTestCase {

    var usersProvider: UsersProvider!
    
    var storageManager: StorageManager!
    
    private let testURL = URL(string: "http://testurl")!
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: UserListTests.self)] )!
        return managedObjectModel
    }()
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "UserList", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        
        let networkManager = NetworkManager(urlSession: MockURLSession())
        storageManager = StorageManager(persistentContainer: mockPersistantContainer)
        usersProvider = UsersProvider(storageManager: storageManager, networkManager: networkManager)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUsersFetchedAndSaved() {
        let initialUsers = self.storageManager.getUsers()
        XCTAssertEqual(0, initialUsers?.count)
        usersProvider.getUsers(page: 1) { (_, error) in
            if let err = error {
                print("Error:", err)
                XCTFail()
            }
            else {
                if let users = self.storageManager.getUsers()?.sorted(by: { return $1.reputation < $0.reputation}) {
                    XCTAssertEqual(30, users.count)
                    XCTAssertEqual(users.first!.displayName, "Marc Gravell")
                    XCTAssertEqual(users.last!.reputation, 31585)
                }
            }
        }
    }
    
}
class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    
    var nextError: Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        let url = Bundle(for: UserListTests.self).url(forResource: "TestData", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        completionHandler(data, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
    
}
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func cancel() {
        cancelled = true
    }
    
    var state: URLSessionTask.State {
        return .running
    }
    
    private (set) var resumeWasCalled = false
    
    private (set) var cancelled = false
    func resume() {
        resumeWasCalled = true
    }
    
}
