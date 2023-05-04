//
//  UserResponse.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 04/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation

struct UserResponse: Decodable {
    let fullname: String
    let email: String
    let key: String?
    let role: Int
}
