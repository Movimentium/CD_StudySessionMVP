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
}


class StudentsListPresenter {
    private let db = DataBase.single
    weak var viewInterface: StudentsListViewInterface?
    
    var numOfRows: Int {
        return 1
    }
    
    func titleForCell(at i:Int) -> String {
        return "hlkjl"
    }
    
    func btnAddStudentPressed() {
        viewInterface?.showAddNewStudentForm()
    }
    
    func addNewStudent(name: String, lastName: String) {
        
    }
    
    func errorTypingNewStudent() {
        viewInterface?.showMsg("No se ha guardado ningún estudiante", isError: true)
    }
    
}
