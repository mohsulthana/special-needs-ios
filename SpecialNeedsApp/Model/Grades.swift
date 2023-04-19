//
//  Grades.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 18/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct Grades {
    let documentID: String
    let name: String
    let subjects: [StudentSubjects.RawValue:[String]]
}
