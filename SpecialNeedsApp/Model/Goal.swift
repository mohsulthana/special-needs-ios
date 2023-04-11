//
//  Goal.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Goal: Object {
    @objc dynamic var id                             = ""
    @objc dynamic var goalName                       = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func saveGoal(_ jsonData: JSON, realm: Realm) -> Goal? {
        //***     Save Goal in Realm
        guard let goalID = jsonData["Id"].string else { return nil }
        
        let goal: Goal!
        
        //***     Check for existing goal
        if let existingGoal = Goal.findById(goalID, realm: realm) as? Goal {
            goal                           = existingGoal
        }
        else {
            //>     Create new Goal instance
            let newGoal: Goal             = Goal()
            goal                           = newGoal
            
            goal.id                        = goalID
            
            realm.add(goal)
        }
        
        goal.goalName = jsonData["Name"].stringValue
        
        return goal
    }
}
