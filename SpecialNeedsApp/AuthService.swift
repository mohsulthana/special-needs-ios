//
//  AuthService.swift
//  SpecialNeedsApp
//
//  Created by Mohammad Sulthan on 11/04/23.
//  Copyright © 2023 Gustavo Ortega. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class AuthService {
    public static let shared = AuthService()

    private init() {}

    /**
        A method to register the user
        - Parameters:
            - userRequest: The users information (email, username, password)
            - completion:  A completion with two values
     */
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                completion(false, error)
                return
            }

            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }

            let db = Firestore.firestore()

            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email,
                ]) { error in
                    if let error {
                        print(error)
                        completion(false, error)
                        return
                    }

                    completion(true, nil)
                }
        }
    }
    
    public func loginUser(with loginRequest: LoginUserRequest, completion: @escaping (Bool, Error) -> Void) {
        let email = loginRequest.email
        let password = loginRequest.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            print(result?.user)
            print(error)
            
        }
    }
    
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userUID)
            .getDocument { snapshot, error in
                if let error {
                    completion(nil, error)
                    return
                }
                
                if let snapshot,
                   let snapshotData = snapshot.data(),
                   let username = snapshotData["username"] as? String,
                   let email = snapshotData["email"] as? String {
                    let user = User(UID: userUID, email: email, username: username)
                    completion(user, nil)
                }
            }
    }
}
