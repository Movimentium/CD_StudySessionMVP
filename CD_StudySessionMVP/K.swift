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
    
    enum Subject: String, CaseIterable {
        case maths = "Matemáticas"
        case physics = "Física"
        case technicalDrawing = "Dibujo técnico"
        case technology = "Tecnología"
        case english = "Inglés"
    }
    
    static let arrMinutes: [Int16] = {
        var arr:[Int16] = []
        var min:Int16 = 15
        for i in 1...7 {
            min += 15
            arr.append(min)
        }
        return arr
    }()
    
    struct VCId {
        static let sessionsVC = "SessionsVC"
    }
    
    static let animTime: TimeInterval = 0.25
    static let msgTime: TimeInterval = 0.75
}
