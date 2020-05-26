//
//  AddSessionPresenter.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 26/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

protocol AddSessionViewInterface: AnyObject {
    func dismiss()
}

protocol AddSessionPresenterDelegate: AnyObject {
    func didAddSession(withError errorMsg: String?)
}

class AddSessionPresenter {
    private let db = DataBase.single
    weak var viewInterface: AddSessionViewInterface?
    weak var delegate: AddSessionPresenterDelegate?
    
    let studentIdx: Int

    var beginDate: Date!
    var mins: Int16!
    var subject: String!
    
    init(studentIdx:Int) {
        self.studentIdx = studentIdx
    }
    
    func add() {
        db.add(at: studentIdx, beginDate: beginDate,
               mins: mins, subject: subject)
        delegate?.didAddSession(withError: nil)
        viewInterface?.dismiss()
    }
    
    
}
