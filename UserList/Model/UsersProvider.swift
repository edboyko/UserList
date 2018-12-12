//
//  EmployeesProvider.swift
//  UserList
//
//  Created by Edwin Boyko on 04/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation
import CoreData

class UsersProvider {
    
    private static let baseURL = "https://api.stackexchange.com/2.2/users/moderators"
    
    let storageManager: StorageManager
    let networkManager: NetworkManager
    private(set) var hasMorePages = true
    private(set) var currentPage = 1
    
    init(storageManager: StorageManager = StorageManager(), networkManager: NetworkManager = NetworkManager()) {
        self.storageManager = storageManager
        self.networkManager = networkManager
    }
    
    func getUsers(page: Int = 0, completion: @escaping ([PersistentUser]?, Error?) -> Void) {
        guard var urlComponents = URLComponents(string: UsersProvider.baseURL) else {
            return
        }
        let pageString = NSNumber(value: currentPage).stringValue
        
        urlComponents.queryItems = [
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "page", value: pageString),
            URLQueryItem(name: "sort", value: "reputation"),
            URLQueryItem(name: "order", value: "desc")
        ]
        let url = urlComponents.url!
        networkManager.loadData(url: url) { (data, error) in
            if let error = error as NSError? {
                if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut {
                    let persistentUsers = self.storageManager.getUsers()
                    self.hasMorePages = false
                    completion(persistentUsers, error)
                }
                else {
                    completion(nil, error)
                }
            }
            else if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let response = try decoder.decode(UserResponseModel.self, from: data)
                    let users = response.items
                    self.hasMorePages = response.hasMore
                    
                    let persistentUsers = self.storageManager.save(users: users)
                    self.currentPage += 1
                    completion(persistentUsers, nil)
                    
                }
                catch {
                    completion(nil, error)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
}

