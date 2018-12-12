//
//  PersistentUser+CoreDataProperties.swift
//  UserList
//
//  Created by Edwin Boyko on 05/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//
//

import Foundation
import CoreData


extension PersistentUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistentUser> {
        return NSFetchRequest<PersistentUser>(entityName: "PersistentUser")
    }

    @NSManaged public var accountId: Int64
    @NSManaged public var creationDate: Date
    @NSManaged public var displayName: String
    @NSManaged public var profileImage: URL?
    @NSManaged public var reputation: Int64
    @NSManaged public var userId: Int64
    
    var creationDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self.creationDate)
    }

}
