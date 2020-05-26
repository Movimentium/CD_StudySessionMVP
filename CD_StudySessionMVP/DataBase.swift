//
//  DataBase.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 03/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import CoreData

typealias StudySessionTuple = (strBeginDate:String, mins:Int16, subject:String)

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
    
    func deleteStudent(at i:Int) {
        
    }
    
    func numOfSessions(forStudentAt i:Int) -> Int {
        return arrStudents[i].session?.count ?? 0
    }
    
    func studySession(at j:Int, fotStudentAt i:Int) -> SessionTuple {
        let session = arrStudents[i].session?.object(at: j) as! StudySession
        var sTuple: SessionTuple
        var strDate = "Error"
        if let date = session.beginDate {
            strDate = DateUtils().dateFormOut.string(from: date)
        }
        sTuple.strBeginDate = strDate
        sTuple.subject = session.subject ?? "Error"
        sTuple.minutes = session.minutes
        return sTuple
    }
    
    func deleteStudySession(at i:Int, fotStudentAt studentIdx:Int) -> (msg:String, isError:Bool) {
        guard let obj = arrStudents[studentIdx].session?.object(at: i),
            let session = obj as? StudySession else {
            return ("Error al borrar la sesión",true)
        }
        moctx.delete(session)
        do {
            try moctx.save()
            return ("Sesión borrada",false)
        } catch {
            print("\(DataBase.self) \(#function)")
            print(error.localizedDescription)
            return ("Error al borrar la sesión", true)
        }
    }
    
    
    // MARK: - PRUEBAS
    
    func add(at i:Int, beginDate:Date, mins:Int16, subject:String) {
        let studySessionEnt = NSEntityDescription.entity(forEntityName: "\(StudySession.self)", in: moctx)!
        let studySession = StudySession(entity: studySessionEnt, insertInto: moctx)
        
        studySession.beginDate = beginDate
        studySession.minutes = mins
        studySession.subject = subject
        
        let sessions = arrStudents[i].session!.mutableCopy() as! NSMutableOrderedSet
        sessions.add(studySession)
        arrStudents[i].session = sessions
        
        saveContext()
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
