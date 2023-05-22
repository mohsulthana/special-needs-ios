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
import IQKeyboardManagerSwift
import RealmSwift
import UIKit

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

//        createFirestoreData()
        UserDefaults.standard.removeObject(forKey: "superAdminToken")

        return true
    }

    private func createFirestoreData() {
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

        var elaGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "ela", goals: [])
        
        var augmentedCommunicationGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "augmented_and_alternative_communication", goals: [])
        var phonologicalGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "phonological", goals: [])
        var expressiveGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "expressive_language", goals: [])
        var receptiveGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "receptive_language", goals: [])
        var articulation: SubjectGoalsModel = SubjectGoalsModel(name: "articulation", goals: [])
        var fluency: SubjectGoalsModel = SubjectGoalsModel(name: "fluency", goals: [])
        
        var cuttingGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "cutting", goals: [])
        var blockPuzzleGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "blocks_and_puzzles", goals: [])
        var drawingGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "drawing", goals: [])
        var graspReleaseGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "grasp_and_release", goals: [])
        var selfCareGoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "self_care", goals: [])
        
        var step1GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_1", goals: [])
        var step2GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_2", goals: [])
        var step3GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_3", goals: [])
        var step4GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_4", goals: [])
        var step5GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_5", goals: [])
        var step6GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_6", goals: [])
        var step7GoalsModel: SubjectGoalsModel = SubjectGoalsModel(name: "step_7", goals: [])

        let prek = PrekDataModel(grade: "PreK", subjects: PrekSubject(math: mathGoalsModel, reading: readingGoalsModel, writing: writingGoalsModel, behavior: behaviorGoalsModel, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, fine_motor: fineMotorGoalsModel, gross_motor: grossMotorGoalsModel))

        let kindergaten = FirestoreModel.KindergatenDataModel(grade: "Kindergaten", subjects: FirestoreModel.KindergatenSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math: mathGoalsModel, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))

        let firstGrade = FirestoreModel.FirstGradeDataModel(grade: "1st Grade", subjects: FirestoreModel.FirstGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))

        let secondGrade = FirestoreModel.FirstGradeDataModel(grade: "2nd Grade", subjects: FirestoreModel.FirstGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))

        let thirdGrade = FirestoreModel.FirstGradeDataModel(grade: "3rd Grade", subjects: FirestoreModel.FirstGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))

        let forthGrade = FirestoreModel.FourthGradeDataModel(grade: "4th Grade", subjects: FirestoreModel.FourthGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, behavior: behaviorGoalsModel))

        let fifthGrade = FirestoreModel.FirstGradeDataModel(grade: "5th Grade", subjects: FirestoreModel.FirstGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, communication: communicationGoalsModel, behavior: behaviorGoalsModel))

        let sixthGrade = FirestoreModel.FourthGradeDataModel(grade: "6th Grade", subjects: FirestoreModel.FourthGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, behavior: behaviorGoalsModel))

        let seventhGrade = FirestoreModel.FourthGradeDataModel(grade: "7th Grade", subjects: FirestoreModel.FourthGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, behavior: behaviorGoalsModel))

        let eigthGrade = FirestoreModel.FourthGradeDataModel(grade: "8th Grade", subjects: FirestoreModel.FourthGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading_fluency: readingFluencyGoalsModel, writing: writingGoalsModel, math_computation: mathComputationGoalsModel, math_word_problem: mathWordProblem, social_skills: socialSkillsGoalsModel, behavior: behaviorGoalsModel))

        let ninthTenGrade = FirestoreModel.NinthTenDataModel(grade: "9th & 10th Grade", subjects: FirestoreModel.NinthTenGradeSubject(reading_comprehesion: readingComprehesionGoalsModel, reading: readingGoalsModel, writing: writingGoalsModel, social_skills: socialSkillsGoalsModel, behavior: behaviorGoalsModel))

        let eleventhTwelve = FirestoreModel.EvelenthTwelvethDataModel(grade: "11th & 12th Grade", subjects: FirestoreModel.EleventhTwelvethGradeSubject(ELA: elaGoalsModel, writing: writingGoalsModel, math: mathGoalsModel), position: 12)
        
        let SLPGrade = FirestoreModel.SLPDataModel(grade: "SLP", subjects: FirestoreModel.SLPGradeSubject(augmented_and_alterative_communication: augmentedCommunicationGoalsModel, phonological: phonologicalGoalsModel, expressive_language: expressiveGoalsModel, receptive_language: receptiveGoalsModel, articulation: articulation, fluency: fluency), position: 13)
                                                   
        let OTGrade = FirestoreModel.OTDataModel(grade: "OT", subjects: FirestoreModel.OTGradeSubject(cutting: cuttingGoalsModel, blocks_and_puzzles: blockPuzzleGoalsModel, drawing: drawingGoalsModel, writing: writingGoalsModel, grasp_and_release: graspReleaseGoalsModel, self_care: selfCareGoalsModel), position: 14)
        
        let IEPGrade = FirestoreModel.IEPDataModel(grade: "IEP Process", subjects: FirestoreModel.IEPGradeSubject(step_1: step1GoalsModel, step_2: step2GoalsModel, step_3: step3GoalsModel, step_4: step4GoalsModel, step_5: step5GoalsModel, step_6: step6GoalsModel, step_7: step7GoalsModel), position: 15)

        let db = Firestore.firestore()
        
        try? db.collection("grades").document().setData(from: prek) { err in
            if let err {
                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
                return
            }
            self.window?.rootViewController?.view.makeToast("Success")
        }
        
//        try? db.collection("grades").document().setData(from: kindergaten) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//        
//        try? db.collection("grades").document().setData(from: firstGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//        
//
//        try? db.collection("grades").document().setData(from: secondGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: thirdGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: forthGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: fifthGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: sixthGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: seventhGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: eigthGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: ninthTenGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//
//        try? db.collection("grades").document().setData(from: eleventhTwelve) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//        
//        try? db.collection("grades").document().setData(from: SLPGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//        
//        try? db.collection("grades").document().setData(from: OTGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
//        
//        try? db.collection("grades").document().setData(from: IEPGrade) { err in
//            if let err {
//                self.window?.rootViewController?.view.makeToast(err.localizedDescription)
//                return
//            }
//            self.window?.rootViewController?.view.makeToast("Success")
//        }
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
