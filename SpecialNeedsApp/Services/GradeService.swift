//
//  GradeService.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 18/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GradeService: ObservableObject {
    public static let shared = GradeService()
    
    private init() {}
    
    @Published var grade: Grades?
    
    public func fetchGrades(completion: @escaping ([Grades]?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("grades").order(by: "position").getDocuments { (querySnapshot, err) in
            
            if let err = err as NSError? {
                completion(nil, err)
                return
            }
            
            var grades: [Grades] = []
            
            if let document = querySnapshot?.documents {
                do {
                    for doc in document {
                        let datas = try? doc.data(as: GradeResponse.self)
                        
                        if let datas {
                            let grade: Grades = Grades(documentID: doc.documentID, grade: datas.grade, subjects: datas.subjects)
                            grades.append(grade)
                        }
                    }
                }
            }
            
            completion(grades, nil)
        }
    }
    
    public func addNewGrade(with gradeRequest: NewGradeRequest?, completion: @escaping (Bool?, String?) -> Void) {
        let db = Firestore.firestore()
        
        guard let gradeRequest else {
            completion(false, "All data should be filled")
            return
        }
        
        let name = gradeRequest.name
        let subjects = gradeRequest.subjects
        
        
        db.collection("grades").document()
            .setData([
                "name": name,
                "subjects": subjects
            ]) { error in
                if let error {
                    completion(false, error.localizedDescription)
                    return
                }

                completion(true, nil)
            }
    }
}
