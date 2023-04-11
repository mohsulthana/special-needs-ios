//
//  Object+Extensions.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/26/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    static func all() -> [Object]? {
        do {
            let realm = try Realm()
            
            let obj = realm.objects(self)
            
            return obj.toArray(self)
        } catch {
            debugPrint("ream error")
            
            return nil
        }
    }
    
    static func findById(_ id: String) -> Object? {
        do {
            let realm = try Realm()
            
            let newID = id.replacingOccurrences(of: "'", with: "\\'")
            
            let obj = realm.objects(self).filter("id = '\(newID)'")
            
            return obj.first
        } catch {
            debugPrint("realm error")
            
            return nil
        }
    }
    
    static func findById(_ id: String, realm: Realm) -> Object? {
        let obj         = realm.objects(self).filter("id = '\(id)'")
        
        return obj.first
    }
    
    static func findByIdLocal(_ idLocal: String) -> Object? {
        do {
            let realm = try Realm()
            
            let newIDLocal = idLocal.replacingOccurrences(of: "'", with: "\\'")
            
            let obj = realm.objects(self).filter("idLocal = '\(newIDLocal)'")
            
            return obj.first
        } catch {
            debugPrint("realm error")
            
            return nil
        }
    }
    
    static func find(_ query: String) -> [Object]? {
        do {
            let realm = try Realm()
            
            let obj = realm.objects(self).filter(query)
            
            return obj.toArray(self)
        } catch {
            debugPrint("realm error")
            
            return nil
        }
    }
}

extension Results {
    func toArray<T>(_ ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}
