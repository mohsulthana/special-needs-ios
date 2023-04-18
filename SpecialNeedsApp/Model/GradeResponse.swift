//
//  GradeResponse.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 18/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct GradeResponse {
    @DocumentID var id: String?
    let name: String
    let subjects: SubjectResponse
}

struct SubjectResponse {
    let name: StudentSubjects
}

enum StudentSubjects: String {
    case math = "Math"
    case behavior = "Behavior"
    case communication = "Communication"
}

enum GradesNaming: String, CaseIterable {
    case prek = "PREK"
}
