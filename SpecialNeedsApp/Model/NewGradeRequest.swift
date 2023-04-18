//
//  NewGradeRequest.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 19/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct NewGradeRequest: Encodable {
    let name: String
    let subjects: [String: [String]]
}
