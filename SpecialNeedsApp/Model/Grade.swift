//
//  Grade.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Grade: Object{
    
    @objc dynamic var id = ""
    @objc dynamic var gradeName = ""
    
    var arrSubjects = List<Subject>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    //MARK: - Create Methods
    
    static func saveGrades(_ jsonData:JSON) {
        let realm = try! Realm()
        
        do {
            try realm.write {
                var oldGradesIds:[String] = realm.objects(Grade.self).map { $0.id }
                
                for jsonGrades in jsonData.arrayValue {
                    if let grade = Grade.saveGrade(jsonGrades, realm: realm) {
                        if let index = oldGradesIds.firstIndex(of: grade.id) {
                            oldGradesIds.remove(at: index)
                        }
                    }
                }
            }
            
        } catch let error {
            appDelegate.genericErrorOccurred(error)
        }
    }
    
    static func saveGrade(_ jsonData: JSON, realm: Realm) -> Grade? {
        //***     Save grade in Realm
        let gradeID = jsonData["Id"].stringValue
        
        let grade: Grade!
        
        //***     Check for existing grade
        if let existingGrade = Grade.findById(gradeID, realm: realm) as? Grade {
            grade                = existingGrade
        }
        else {
            //***     Create new Grade instance
            let newGrade: Grade         = Grade()
            grade                      = newGrade
            
            grade!.id                  = gradeID
            
            realm.add(grade)
        }
        
        grade.gradeName = jsonData["Name"].stringValue
        
        if let arrTempSubjects = jsonData["Subjects"].array {
            grade.arrSubjects.removeAll()
            
            for subject in arrTempSubjects {
                if let obj = Subject.saveSubject(subject, realm: realm) {
                    if !grade.arrSubjects.contains(obj) {
                        grade.arrSubjects.append(obj)
                    }
                }
            }
        }
        
        return grade
    }
}

