//
//  FirestoreModel.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct PrekDataModel: Encodable {
    let grade: String?
    let subjects: PrekSubject?
}

struct PrekSubject: Encodable {
    let math: SubjectGoalsModel?
    let reading: SubjectGoalsModel?
    let writing: SubjectGoalsModel?
    let behavior: SubjectGoalsModel?
    let social_skills: SubjectGoalsModel?
    let communication: SubjectGoalsModel?
    let fine_motor: SubjectGoalsModel?
    let gross_motor: SubjectGoalsModel?
}

struct SubjectGoalsModel: Encodable {
    let name: String
    let goals: [String]
}
