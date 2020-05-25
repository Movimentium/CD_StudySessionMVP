//
//  K.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 07/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

typealias SessionTuple = (subject:String, strBeginDate:String, minutes:Int16)

struct K {
    
    enum Subject {
        case maths
        case physics
    }
    
    struct VCId {
        static let sessionsVC = "SessionsVC"
    }
    
    static let animTime: TimeInterval = 0.25
    static let msgTime: TimeInterval = 0.75
}
