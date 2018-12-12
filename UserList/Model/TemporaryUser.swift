//
//  Employee.swift
//  UserList
//
//  Created by Edwin Boyko on 04/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation
struct UserResponseModel: Decodable {
    let items: [TemporaryUser]
    let hasMore: Bool
}

struct TemporaryUser: Decodable {
    let accountId: Int
    let userId: Int
    let creationDate: Date
    let displayName: String
    let reputation: Int
    let profileImage: URL?
    
    func map(to persistentUser: PersistentUser) {
        persistentUser.accountId = Int64(self.accountId)
        persistentUser.userId = Int64(self.userId)
        persistentUser.creationDate = self.creationDate
        persistentUser.displayName = self.displayName
        persistentUser.reputation = Int64(self.reputation)
        persistentUser.profileImage = self.profileImage
    }
}
