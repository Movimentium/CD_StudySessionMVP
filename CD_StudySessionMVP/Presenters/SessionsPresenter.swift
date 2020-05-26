//
//  SessionsPresenter.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 07/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

protocol SessionsViewInterface: AnyObject {
    func reloadData()
}

 
class SessionsPresenter: AddSessionPresenterDelegate {
  
    private let db = DataBase.single
    weak var viewInterface: SessionsViewInterface?
    
    private(set) var isEditMode: Bool = false
    let studentIdx: Int
    
    init(studentIdx:Int) {
        self.studentIdx = studentIdx
    }
    
    var numOfRows:Int {
        return db.numOfSessions(forStudentAt: studentIdx)
    }
    
    func session(at i:Int) -> SessionTuple {
        return db.studySession(at: i, fotStudentAt: studentIdx)
    }
    
    func deleteSession(at i:Int) -> (msg:String, isError: Bool) {
        let response = db.deleteStudySession(at: i, fotStudentAt: studentIdx)
        // TODO: Gestionar errores
        return response
    }
    
    func btnBtnEditPressed() {
        isEditMode = !isEditMode
    }
    
    // MARK: - AddSessionPresenterDelegate
    
    func didAddSession(withError errorMsg: String?) {
        viewInterface?.reloadData()
    }
      


}
