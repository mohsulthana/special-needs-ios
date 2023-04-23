//
//  NewGoalRequest.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct NewGoalRequest: Codable {
    let documentID: String
    let goal: String
    let subjectName: SubjectName?
}
