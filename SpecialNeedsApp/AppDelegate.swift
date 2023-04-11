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

        setupRealm()

        if #available(iOS 13.0, *) {
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let baseNC = mainStoryboard.instantiateViewController(withIdentifier: "Base_NC") as! UINavigationController
            window?.rootViewController = baseNC

            window?.makeKeyAndVisible()
        }

        return true
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
