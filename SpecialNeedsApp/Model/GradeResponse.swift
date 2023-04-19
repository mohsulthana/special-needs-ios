//
//  GradeResponse.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 18/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct GradeResponse: Codable {
    let name: String
    let subjects: [StudentSubjects.RawValue:[String]]
}

enum StudentSubjects: String, Decodable {
    case math = "Math"
    case behavior = "Behavior"
    case communication = "Communication"
    case other
    
    init(from decoder: Decoder) throws {
      let label = try decoder.singleValueContainer().decode(String.self)
      self = StudentSubjects(rawValue: label) ?? .other
    }
}
