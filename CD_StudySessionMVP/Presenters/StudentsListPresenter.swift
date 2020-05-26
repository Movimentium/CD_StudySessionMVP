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
    func navigateToSessionList(forStudentIdx i:Int)
}


class StudentsListPresenter {
    private let db = DataBase.single
    weak var viewInterface: StudentsListViewInterface?

    private(set) var isEditMode: Bool = false
    
    var numOfRows: Int {
        return db.numOfStudents
    }
    
    func titleForCell(at i:Int) -> String {
        return db.studentFullName(at: i)
    }
    
    func didSelectStudent(at i:Int) {
        viewInterface?.navigateToSessionList(forStudentIdx: i)
    }
    
    func btnAddStudentPressed() {
        viewInterface?.showAddNewStudentForm()
    }
    
    func btnBtnEditPressed() {
        isEditMode = !isEditMode
    }
    
    
    func addNewStudent(name: String, lastName: String) {
        let response = db.addStudent(name, lastName)
        viewInterface?.showMsg(response.msg, isError: response.isError)
        viewInterface?.reloadData()
    }
    
    func deleteStudent(at i:Int) -> (msg:String, isError: Bool) {
        let response = db.deleteStudent(at: i)
        viewInterface?.showMsg(response.msg, isError: response.isError)
        return response
    }
    
    
    func errorTypingNewStudent() {
        viewInterface?.showMsg("No se ha guardado ningún estudiante", isError: true)
    }
    
}
