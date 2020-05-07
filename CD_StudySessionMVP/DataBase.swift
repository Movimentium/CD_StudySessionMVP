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
    private init() {
        requestArrStudents()
    }
    
    private var arrStudents: [Student] = []
    
    var numOfStudents: Int {
        return arrStudents.count
    }
    
    func studentFullName(at i:Int) -> String {
        if i < arrStudents.count {
            let student = arrStudents[i]
            return "\(student.firstName ?? "") \(student.lastName ?? "") "
        } else {
            return ""
        }
    }
    
    private func requestArrStudents() {
        arrStudents = []
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "\(Student.self)")
        arrStudents = try! moctx.fetch(fr) as? [Student] ?? []
    }
    
    func addStudent(_ name:String, _ lastName:String) ->  (msg:String, isError:Bool) {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "\(Student.self)")
        fr.resultType = .countResultType
        fr.predicate = NSPredicate(format: "firstName = %@ AND lastName = %@", name, lastName)
        do {
            let num = try moctx.fetch(fr).first as! Int
            if num == 0 {
                let studentEnt = NSEntityDescription.entity(forEntityName: "\(Student.self)", in: moctx)!
                let student = Student(entity: studentEnt, insertInto: moctx)
                student.firstName = name
                student.lastName = lastName
                try moctx.save()
                requestArrStudents()
                return ("Estudiante guardado", false)
            } else {
                return ("Ya existe el estudiante", true)
            }
        } catch {
            print("\(DataBase.self) \(#function)")
            print(error.localizedDescription)
            return ("Error al añadir el estudiante", true)
        }
    }
    
    
    

    
    
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
