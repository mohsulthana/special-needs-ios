//
//  FirebaseHelper.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 21/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import FirebaseFirestore

class FirebaseHelper {
    public static let shared = FirebaseHelper()

    private init() {}
    
    public func userCollection() -> CollectionReference {
        let db = Firestore.firestore()
        return db.collection("users")
    }
    
    public func gradeCollection() -> CollectionReference {
        let db = Firestore.firestore()
        return db.collection("grades")
    }
}
