//
//  AddStudentTargetRequest.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct AddStudentTargetRequest: Encodable {
    let grade: String
    let subject: String
    let goal: String
    let interval: String
    let endDate: Double
}
