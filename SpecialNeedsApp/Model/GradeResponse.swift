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
    var array: [SubjectGoals]

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

enum SubjectName: String, Codable {
    case math = "Math"
    case behavior = "Behavior"
    case communication = "Communication"
    case reading = "Reading"
    case writing = "Writing"
    case social_skills = "Social Skills"
    case fine_motor = "Fine Motor"
    case gross_motor = "Gross Motor"
    case reading_comprehesion = "Reading Comprehension"
    case reading_fluency = "Reading Fluency"
    case math_word_problem = "Math Word Problem"
    case math_computation = "Math Computation"
    case ela = "ELA"
    case articulation = "Articulation"
    case augmented_and_alterative_communication = "Augmented and Alternative Communication"
    case expressive_language = "Expressive Language"
    case fluency = "Fluency"
    case phonological = "Phonological"
    case receptive_language = "Receptive Language"
    case blocks_and_puzzles = "Blocks & Puzzles"
    case cutting = "Cutting"
    case drawing = "Drawing"
    case grasp_and_release = "Grasp & Release"
    case self_care = "Self Care"
    case step_1 = "Step 1. Referral"
    case step_2 = "Step 2. Evaluation"
    case step_3 = "Step 3. Eligibility"
    case step_4 = "Step 4. The Meeting"
    case step_5 = "Step 4a. The Guts of the IEP's"
    case step_6 = "Step 5. Reevaluation"
    case step_7 = "The Federal Law (IDEA)"
    case other = "Other"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let subject = try? container.decode(String.self)

        switch subject {
        case "math": self = .math
        case "behavior": self = .behavior
        case "communication": self = .communication
        case "reading": self = .reading
        case "writing": self = .writing
        case "fine_motor": self = .fine_motor
        case "gross_motor": self = .gross_motor
        case "social_skills": self = .social_skills
        case "reading_fluency": self = .reading_fluency
        case "reading_comprehesion": self = .reading_comprehesion
        case "math_word_problem": self = .math_word_problem
        case "math_computation": self = .math_computation
        case "ela": self = .ela
        case "articulation": self = .articulation
        case "augmented_and_alterative_communication": self = .augmented_and_alterative_communication
        case "expressive_language": self = .expressive_language
        case "fluency": self = .fluency
        case "phonological": self = .phonological
        case "receptive_language": self = .receptive_language
        case "blocks_and_puzzles": self = .blocks_and_puzzles
        case "cutting": self = .cutting
        case "drawing": self = .drawing
        case "grasp_and_release": self = .grasp_and_release
        case "self_care": self = .self_care
        case "step_1": self = .step_1
        case "step_2": self = .step_2
        case "step_3": self = .step_3
        case "step_4": self = .step_4
        case "step_5": self = .step_5
        case "step_6": self = .step_6
        case "step_7": self = .step_7
            
        default:
            self = .other
        }
    }
}
