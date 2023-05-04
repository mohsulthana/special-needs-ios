//
//  UserService.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 04/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import FirebaseFirestore

class UserService {
    public static let shared = UserService()

    private init() {}
    
    public func unlockSuperadminAccess(inputtedKey: String, completion: @escaping (String?, String?) -> Void) {
        FirebaseHelper.shared.userCollection().getDocuments { querySnapshot, error in
            if let error {
                completion(nil, error.localizedDescription)
                return
            }
            
            for document in querySnapshot!.documents {
                let data = try? document.data(as: UserResponse.self)
            
                guard let key = data?.key else {
                    continue
                }
                
                if key != inputtedKey {
                    continue
                }
                
                if data?.role != 0 {
                    completion(nil, "Key found, but you don't have access to this action. Please contact administrator")
                } else if key.isEmpty {
                    completion(nil, "Key not found. Please try again with another key")
                } else {
                    completion(key, nil)
                }
            }
        }
    }
}

