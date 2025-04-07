//
//  Month.swift
//  MedicalShift
//
//  Created by 千々岩真吾 on 2025/04/06.
//

import Foundation

struct Month: Identifiable, Equatable {
    let date: Date
    var id: Date { date.startOfMonth }
}
