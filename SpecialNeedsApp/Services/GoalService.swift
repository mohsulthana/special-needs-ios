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

    public func fetchGoals(student: SubjectName?, document: String, completion: @escaping ([String]?, Error?) -> Void) {
        let docRef = FirebaseHelper.shared.gradeCollection().document(document)

        Task {
            do {
                let data = try await docRef.getDocument(as: GradeResponse.self)
                if let goals = data.subjects?.array.filter({ $0.name?.rawValue == student?.rawValue }) {
                    completion(goals[0].goals, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
    }

    public func deleteGoal(goal: String, key: SubjectName, documentID: String, completion: @escaping (Error?) -> Void) {
        FirebaseHelper.shared.gradeCollection().document(documentID)
            .updateData([
                "subjects.\(key).goals": FieldValue.arrayRemove([goal]),
            ]) { err in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
    }

    public func createNewGoals(with data: NewGoalRequest, completion: @escaping (Error?) -> Void) {
        FirebaseHelper.shared.gradeCollection().document(data.documentID)
            .updateData([
                "subjects.\(String(describing: data.subjectName!).lowercased()).goals": FieldValue.arrayUnion([data.goal]),
            ]) { err in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
    }
    
    public func updateGoals(goal: [String], key: SubjectName, documentID: String, completion: @escaping (Error?) -> Void) {
        FirebaseHelper.shared.gradeCollection().document(documentID)
            .updateData([
                "subjects.\(String(describing: key).lowercased()).goals": goal,
            ]) { err in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
    }
}
