//
//  StudentsListPresenter.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 04/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

protocol StudentsListViewInterface: AnyObject {
    func showAddNewStudentForm()
    func showMsg(_ msg:String, isError:Bool)
    func reloadData()
}


class StudentsListPresenter {
    private let db = DataBase.single
    weak var viewInterface: StudentsListViewInterface?
    
    var numOfRows: Int {
        return db.numOfStudents
    }
    
    func titleForCell(at i:Int) -> String {
        return db.studentFullName(at: i)
    }
    
    func btnAddStudentPressed() {
        viewInterface?.showAddNewStudentForm()
    }
    
    func addNewStudent(name: String, lastName: String) {
        let response = db.addStudent(name, lastName)
        viewInterface?.showMsg(response.msg, isError: response.isError)
        viewInterface?.reloadData()
    }
    
    func errorTypingNewStudent() {
        viewInterface?.showMsg("No se ha guardado ningún estudiante", isError: true)
    }
    
}