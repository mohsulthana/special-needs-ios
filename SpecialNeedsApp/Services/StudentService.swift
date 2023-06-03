//
//  StudentService.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 08/05/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import FirebaseFirestore
import Foundation

class StudentService {
    public static let shared = StudentService()

    private init() {}

    /**
     A method to register the user
     - Parameters:
     - userRequest: The users information (email, username, password)
     - completion:  A completion with two values
     */
    public func fetchAllStudents(completion: @escaping ([StudentsModel]?, String?) -> Void) async {
        do {
            let querySnapshot = try await FirebaseHelper.shared.studentCollection().getDocuments()
            var students: [StudentsModel] = []
            for doc in querySnapshot.documents {
                let student = try? doc.data(as: StudentResponse.self)
                var studentProgress: ProgressModel?

                do {
                    let progress: ProgressModel = try await getStudentProgress(documentID: doc.documentID) ?? ProgressModel(goal: nil, grade: nil, subject: nil, data: nil, documentID: nil, endDate: nil)
                    studentProgress = progress
                } catch {
                    print("Error: \(error)")
                    continue
                }

                let item: StudentsModel = StudentsModel(name: student?.name ?? "", progress: studentProgress ?? ProgressModel(goal: nil, grade: nil, subject: nil, data: nil, documentID: nil, endDate: nil), documentID: doc.documentID)
                students.append(item)
            }
            completion(students, nil)
        } catch {
            completion(nil, "Error")
        }
    }

    public func getStudentProgress(documentID: String) async -> ProgressModel? {
        do {
            let querySnapshot = try await FirebaseHelper.shared.studentCollection().document(documentID).collection("progress").getDocuments()
            if let doc = try? querySnapshot.documents.first?.data(as: ProgressModel.self) {
                let progress = ProgressModel(goal: doc.goal ?? "", grade: doc.grade ?? "", subject: doc.subject ?? "", data: doc.data, documentID: querySnapshot.documents.first?.documentID, endDate: doc.endDate ?? 0)
                return progress
            }
        } catch {
            return nil
        }

        return nil
    }

    public func addStudentTarget(target: AddStudentTargetRequest, documentID: String, completion: @escaping (Bool?, Error?) -> Void) {
        FirebaseHelper.shared.studentCollection().document(documentID).collection("progress").document()
            .setData([
                "grade": target.grade,
                "subject": target.subject,
                "goal": target.goal,
                "endDate": target.endDate,
                "data": [ScoreData](),
            ]) { error in
                if let error {
                    completion(false, error.localizedDescription as? Error)
                    return
                }

                completion(true, nil)
            }
    }

    public func addProgress(request: AddProgressRequest, completion: @escaping (Error?) -> Void) {
        FirebaseHelper.shared.studentCollection().document(request.documentID).collection("progress").document(request.progressID)
            .setData([
                "data": FieldValue.arrayUnion([["time": request.date, "score": request.score] as [String: Any]]),
            ], merge: true) { err in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
    }

    public func fetchStudentDetail(document: String, completion: @escaping (Bool?, String?) -> Void) {
        FirebaseHelper.shared.studentCollection().document(document).getDocument { document, _ in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }

    public func fetchStudentProgress(documentID: String, progressID: String, completion: @escaping (ProgressModel?, String?) -> Void) {
        let docRef = FirebaseHelper.shared.studentCollection().document(documentID).collection("progress").document(progressID)

        Task {
            do {
                let student = try await docRef.getDocument().data(as: ProgressModel.self)
                let studentProgress: ProgressModel = ProgressModel(goal: student.goal, grade: student.grade, subject: student.subject, data: student.data, documentID: student.documentID, endDate: student.endDate)
                completion(studentProgress, nil)
            } catch {
                completion(nil, "Error")
            }
        }
    }

    public func addNewStudent(name: String, completion: @escaping (Bool?, String?) -> Void) {
        FirebaseHelper.shared.studentCollection().document()
            .setData([
                "name": name,
            ]) { error in
                if let error {
                    completion(false, error.localizedDescription)
                    return
                }

                completion(true, nil)
            }
    }
}
