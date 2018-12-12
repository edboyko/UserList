//
//  File.swift
//  UserList
//
//  Created by Edwin Boyko on 04/12/2018.
//  Copyright © 2018 Edwin Boyko. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer = AppDelegate.instance.persistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func getUsers(with predicate: NSPredicate? = nil) -> [PersistentUser]? {
        let request: NSFetchRequest<PersistentUser> = PersistentUser.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "reputation", ascending: false)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        request.fetchBatchSize = 30
        var users: [PersistentUser]?
        mainContext.performAndWait {
            users = try? mainContext.fetch(request)
        }
        return users
    }
    
    func save(users: [TemporaryUser]) -> [PersistentUser]? {
        
        let context = self.persistentContainer.newBackgroundContext()
        
        let userIds = users.map { return $0.userId }
        let predicate = NSPredicate(format: "userId in %@", argumentArray: [userIds])
        context.performAndWait {
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.undoManager = nil
            
            let request: NSFetchRequest<PersistentUser> = PersistentUser.fetchRequest()
            request.predicate = predicate
            
            do {
                let existingUsers = try context.fetch(request)
                existingUsers.forEach { context.delete($0) }
            } catch {
                return
            }
        
            users.forEach {
                
                let newUser = PersistentUser(context: context)
                $0.map(to: newUser)
            }
            do {
                try context.save()
            } catch {
                return
            }
        }
        
        return self.getUsers(with: predicate)
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
