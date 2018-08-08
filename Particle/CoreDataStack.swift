//
//  CoreDataStack.swift
//  Particle
//
//  Created by Artem Misesin on 6/28/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    // MARK: - Shared Instance
    
    static var shared = CoreDataStack()

    // MARK: - Core Data stack
    
    static var applicationDocumentsDirectory: NSURL = {
        /*
         The directory the application uses to store the Core Data store file.
         This code uses a directory named 'Bundle identifier' in the application's documents Application Support directory.
        */
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    static var managedObjectModel: NSManagedObjectModel = {
        /*
        The managed object model for the application. This property is not optional.
        It is a fatal error for the application not to be able to find and load its model.
         */
        guard let modelURL = Bundle.main.url(forResource: "ParticleDB", withExtension: "momd") else {
            preconditionFailure("Unexpectedly found nil")
        }
        if let object = NSManagedObjectModel(contentsOf: modelURL) {
            return object
        } else {
            preconditionFailure("Found nil")
        }
    }()
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        /*
        The persistent store coordinator for the application.
        This implementation creates and return a coordinator, having added the store for the application to it.
        This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        */
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        guard
            let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.particle.shared.coredata")
        else {
            preconditionFailure("Unexpectedly found nil when accessing core data")
        }
        
        let url = directory.appendingPathComponent("ParticleDB.sqlite")//URLByAppendingPathComponent("TutorialAppGroup.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch var error as NSError {
            coordinator = nil
            NSLog("Unresolved error \(error), \(error.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        //print("\(String(describing: coordinator?.persistentStores))")
        return coordinator
    }()
    
    // MARK: - NSManagedObject Contexts
    
    public class func mainQueueContext() -> NSManagedObjectContext {
        guard let context = self.shared.mainQueueCtxt else {
            preconditionFailure("MainQueueContext is nil")
        }
        return context
    }
    
    public class func privateQueueContext() -> NSManagedObjectContext? {
        return self.shared.privateQueueCtxt
    }
    
    lazy var mainQueueCtxt: NSManagedObjectContext? = {
        /*
        Returns the managed object context for the application
        (which is already bound to the persistent store coordinator for the application.)
        This property is optional since there are legitimate error conditions,
        that could cause the creation of the context to fail.
         */
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = CoreDataStack.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    lazy var privateQueueCtxt: NSManagedObjectContext? = {
        /*
        Returns the managed object context for the application
        (which is already bound to the persistent store coordinator for the application.)
        This property is optional since there are legitimate error conditions,
        that could cause the creation of the context to fail.
        */
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = CoreDataStack.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    public class func saveContext() {
        if mainQueueContext().hasChanges {
        do {
            try mainQueueContext().save()
        } catch {
            }
        }
    }
}
