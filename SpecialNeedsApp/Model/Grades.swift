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
    let grade: String
    let subjects: SubjectObject?
    
    var sortedGrade: [SubjectGoals] {
        get {
            let grade = Grades(documentID: self.documentID, grade: self.grade, subjects: self.subjects)
            return grade.subjects?.array.sorted { $0.name?.rawValue ?? "" < $1.name?.rawValue ?? "" } ?? []
        }
    }
}
