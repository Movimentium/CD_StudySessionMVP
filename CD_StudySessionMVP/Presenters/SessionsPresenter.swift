//
//  SessionsPresenter.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 07/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

protocol SessionsViewInterface: AnyObject {
    func nada()
}

class SessionsPresenter {
    private let db = DataBase.single
    weak var viewInterface: SessionsViewInterface?
    
    let studentIdx: Int
    
    init(studentIdx:Int) {
        self.studentIdx = studentIdx
    }
    
    var numOfRows:Int {
        return db.numOfSessions(forStudentAt: studentIdx)
    }
    
    func session(at i:Int) -> SessionTuple {
        db.studySession(at: i, fotStudentAt: studentIdx)
    }
    
    
    
//    func infoForCell(at i:Int) -> (strBeginDate:String, ) {
//        <#function body#>
//    }
    

}
