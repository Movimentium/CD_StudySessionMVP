//
//  DateUtils.swift
//  CD_StudySessionMVP
//
//  Created by Miguel on 25/05/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation

class DateUtils {
    
    let dateFormIn = DateFormatter()
    let dateFormOut = DateFormatter()

    init() {
        dateFormIn.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.000Z"
        dateFormOut.dateFormat = "dd/MM/YYYY HH:mm:ss"
    }
    
}
