//
//  StudentsModel.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 08/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct StudentsModel: Decodable {
    let name: String
    let progress: ProgressModel
    let documentID: String?
}

struct ProgressModel: Decodable {
    let goal: String?
    let grade: String?
    let subject: String?
    let data: [ScoreData]?
    let documentID: String?
    let endDate: Int?
}

struct ScoreData: Decodable {
    let score: Int?
    let time: Int?
}
