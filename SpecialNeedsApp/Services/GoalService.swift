//
//  GoalService.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 20/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import FirebaseFirestore

class GoalService: ObservableObject {
    public static let shared = GoalService()
    
    private init() {}
    
    public func createNewGoals(id: String, key: String, value: String, completion: @escaping(Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("grades").document(id)
            .updateData([
                "subjects.\(key)": FieldValue.arrayUnion([value])
            ]) { err in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
                return
            }
    }
}
