//
//  Subject.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Subject: Object {
    
    @objc dynamic var id                              = ""
    @objc dynamic var subjName                        = ""
    
    var arrGoals                                      = List<Goal>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func saveSubject(_ jsonData: JSON, realm: Realm) -> Subject? {
        //***     Save Subject in Realm
        guard let subjectID = jsonData["Id"].string else { return nil }
        
        let subject: Subject!
        
        //***     Check for existing subject
        if let existingSubject = Subject.findById(subjectID, realm: realm) as? Subject {
            subject                           = existingSubject
        }
        else {
            //***     Create new Subject instance
            let newSubject: Subject             = Subject()
            subject                             = newSubject
            
            subject.id                          = subjectID
            
            realm.add(subject)
        }
        
        subject.subjName                           = jsonData["Name"].stringValue
        
        if let arrTempGoals = jsonData["Goals"].array {
            subject.arrGoals.removeAll()
            
            for goal in arrTempGoals {
                if let obj = Goal.saveGoal(goal, realm: realm) {
                    if !subject.arrGoals.contains(obj) {
                        subject.arrGoals.append(obj)
                    }
                }
            }
        }
        
        return subject
    }
}

