//
//  DataBase.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 03/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import CoreData

class DataBase {
    
    static let single = DataBase()
    private init() {}
    
    
    
    // MARK: - Core Data Stack
    
    private let modelName = "StudentsModel"
    
    private lazy var appDocsDirURL: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    lazy var moctx: NSManagedObjectContext = {
        let theMoctx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        theMoctx.persistentStoreCoordinator = self.psc
        return theMoctx
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        let thePsc = NSPersistentStoreCoordinator(managedObjectModel: self.mom)
        let modelURL = self.appDocsDirURL.appendingPathComponent(self.modelName)
        let dicOptions = [NSMigratePersistentStoresAutomaticallyOption:true]
        do {
            try thePsc.addPersistentStore(ofType: NSSQLiteStoreType,
                                          configurationName: nil,
                                          at: modelURL, options: dicOptions)
        } catch {
            print("\(DataBase.self) \(#function) ERROR:")
            print(error.localizedDescription)
        }
        return thePsc
    }()
    
    private lazy var mom: NSManagedObjectModel = {
        let modelFileURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelFileURL)!
    }()
    
    func saveContext() {
        if moctx.hasChanges {
            do {
                try moctx.save()
            } catch {
                print("\(DataBase.self) \(#function) ERROR:")
                print(error.localizedDescription)
                //abort()  // DANGER
            }
        }
    }
    
    
}
