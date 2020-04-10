//
//  dateConverter.swift
//  Deadliner
//
//  Created by Alfon on 10/04/20.
//  Copyright © 2020 Peter Andrew. All rights reserved.
//

import Foundation

func dateConverter(tanggal: Date) -> String{
    let datetostring = DateFormatter()
    datetostring.dateFormat = "dd MM yyyy, HH:mm"
    return datetostring.string(from: tanggal)
}
