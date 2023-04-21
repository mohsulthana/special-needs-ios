//
//  GradeResponse.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 18/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import FirebaseFirestoreSwift
import Foundation

struct GradeResponse: Decodable {
    let grade: String
    let subjects: SubjectObject?
}

struct SubjectObject: Decodable {
    let array: [SubjectGoals]

    private struct DynamicCodingKeys: CodingKey {
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }

        var stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var tempArray = [SubjectGoals]()

        for key in container.allKeys {
            let decodedObject = try container.decode(SubjectGoals.self, forKey: DynamicCodingKeys(stringValue: key.stringValue))
            tempArray.append(decodedObject)
        }
        
        array = tempArray
    }
}

struct SubjectGoals: Decodable {
    let name: SubjectName?
    let goals: [String]
}

enum SubjectName: String, Decodable {
    case math = "Math"
    case behavior = "Behavior"
    case communication = "Communication"
    case other = "Other"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let subject = try? container.decode(String.self)

        switch subject {
        case "math": self = .math
        case "behavior": self = .behavior
        case "communication": self = .communication
        default:
            self = .other
        }
    }
}
