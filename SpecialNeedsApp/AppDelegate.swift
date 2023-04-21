//
//  AppDelegate.swift
//  SpecialNeedsApp
//
//  Created by Seby Paul on 11/25/19.
//  Copyright © 2019 Gustavo Ortega. All rights reserved.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import RealmSwift
import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // ***     Easy access to NSUserDefaults
    var defaults = UserDefaults.standard

    // ***     Realm Default Storage
    var realm: Realm!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Print docs path just to use for local realm database
        // let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true

//        setupRealm()

        if #available(iOS 13.0, *) {
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let baseNC = mainStoryboard.instantiateViewController(withIdentifier: "Base_NC") as! UINavigationController
            window?.rootViewController = baseNC

            window?.makeKeyAndVisible()
        }
        
        createFirestoreData()

        return true
    }
    
    private func createFirestoreData() {
        let goals: [String] = [""]
        var mathGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "math", goals: [])
        var readingGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "reading", goals: [])
        var writingGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "writing", goals: [])
        var behaviorGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "behavior", goals: [])
        var socialSkillsGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "social_skills", goals: [])
        var communicationGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "communication", goals: [])
        var fineMotorGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "fine_motor", goals: [])
        var grossMotorGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "gross_motor", goals: [])
        
        var readingComprehesionGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "reading_comprehesion", goals: [])
        var readingFluencyGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "reading_fluency", goals: [])
        
        var mathComputationGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "math_computation", goals: [])
        var mathWordProblem: SubjectGoalsModel = SubjectGoalsModel(name: "math_word_problem", goals: [])
        
        let prek = PrekDataModel(grade: "PreK", subjects: PrekSubject(math: mathGoalsModel, reading: readingGoalsModel, writing: writingGoalsModel, behavior: behaviorGoalsModel, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, fine_motor: fineMotorGoalsModel, gross_motor: grossMotorGoalsModel))
        let kindergaten = FirestoreModel.KindergatenDataModel(grade: "Kindergaten", subjects: FirestoreModel.KindergatenSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math: mathGoalsModel, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))
        let firstGrade = FirestoreModel.FirstGradeDataModel(grade: "1st Grade", subjects: FirestoreModel.FirstGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))
        
        let firestoreRequestArray = [prek, kindergaten, firstGrade] as [Any]
        
        let db = Firestore.firestore()

        try? db.collection("grades").document().setData(from: firstGrade) { err in
            if let err {
                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
                return
            }
            self.window?.rootViewController?.view.makeToast("Success")
            return
        }
        
        
    }

    // MARK: - Custom Methods

    func setupRealm() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            //            // Set the block which will be called automatically when opening a Realm with
            //            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < 1 {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        realm = try! Realm()
    }

    func genericErrorOccurred(_ error: Error) {
    }
}

// MARK: - Convenience Constructors

let appDelegate = UIApplication.shared.delegate as! AppDelegate
