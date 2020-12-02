//
//  DataView.swift
//  PaySteps
//
//  Created by Spencer Gray on 11/20/20.
//

import Foundation
import Firebase
import CryptoSwift

class DataView : ObservableObject {
    
    enum SignUpEmail {
        
        case alreadyInUse
        case invalid
        case notDefined
        case valid
    }
    
    enum SignUpPassword {
        
        case doesNotMatch
        case notDefined
        case valid
        case empty
    }
    
    enum SignInPassword {
        
        case invalid
        case valid
        case notDefined
    }
    
    enum SignInEmail {
        
        case invalid
        case notDefined
        case valid
    }
    
    var db: Firestore? = nil
    @Published var currentUser: [String : Any]? = nil
    @Published var loginEmail: SignInEmail = .notDefined
    @Published var verified: SignInPassword = .notDefined
    @Published var passwordConfirmed: SignUpPassword = .notDefined
    @Published var emailFreeToUse: SignUpEmail = .notDefined
    @Published var checkEmailCompletion: (() -> Void)? = nil
    
    static let sharedInstance: DataView = {
        
        let instance = DataView()
        
        FirebaseApp.configure()
        
        instance.db = Firestore.firestore()
        
        return instance
    }()
    
    func addUser(email: String, password: String, confirmPassword: String) {
        
        if password == confirmPassword {
            DataView.sharedInstance.passwordConfirmed = .valid
        } else {
            DataView.sharedInstance.passwordConfirmed = .doesNotMatch
        }
        
        if password == "" {
            DataView.sharedInstance.passwordConfirmed = .empty
        }
        
        validateSignUpEmail(email: email, completion: {
            if DataView.sharedInstance.passwordConfirmed == .valid && DataView.sharedInstance.emailFreeToUse == .valid {
                
                if !email.contains("@") || !email.contains(".") {
                    DataView.sharedInstance.emailFreeToUse = .invalid
                }
                
                if DataView.sharedInstance.emailFreeToUse == .valid {
                    var ref: DocumentReference? = nil
                    ref = self.db!.collection("users").addDocument(data: [
                        "email": email,
                        "password": "hbox\(password)salty".sha256(),
                        "balance": 0
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            DataView.sharedInstance.getUser(documentID: ref!.documentID)
                        }
                    }
                }
            }
        })
        
    }
    
    func validateSignUpEmail(email: String, completion: @escaping () -> Void) {
        
        let userRef = db!.collection("users")
        
        DataView.sharedInstance.emailFreeToUse = .notDefined
        
        userRef.whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {

                    if querySnapshot!.documents.first != nil {
                        
                        DataView.sharedInstance.emailFreeToUse = .alreadyInUse
                    } else {
                        DataView.sharedInstance.emailFreeToUse = .valid
                    }
                }
            }
        
        let queue = OperationQueue()
        DataView.sharedInstance.checkEmailCompletion = completion
        queue.addOperation {
            while DataView.sharedInstance.emailFreeToUse == .notDefined {}
            DataView.sharedInstance.checkEmailCompletion!()
        }
    }
    
    func getUser(documentID: String) {
        
        let docRef = db!.collection("users").document(documentID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                DataView.sharedInstance.currentUser = document.data()
                DataView.sharedInstance.loginEmail = .valid
                DataView.sharedInstance.verified = .valid
            } else {
                print("Document does not exist")
                DataView.sharedInstance.loginEmail = .invalid
            }
        }
    }
    
    func getUser(email: String) {
        
        let userRef = db!.collection("users")
        DataView.sharedInstance.loginEmail = .notDefined
        
        userRef.whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {

                    //print("\(querySnapshot!.documents.first!.documentID) => \(querySnapshot!.documents.first!.data())")
                    
                    if let user = querySnapshot!.documents.first {
                        
                        DataView.sharedInstance.currentUser = user.data()
                        DataView.sharedInstance.loginEmail = .valid
                    } else {
                        DataView.sharedInstance.loginEmail = .invalid
                    }
                }
            }
    }
    
    func verifyPassword(password: String) {
        
        DataView.sharedInstance.verified = .notDefined
        
        let pass = "hbox\(password)salty".sha256()
        
        if let user = DataView.sharedInstance.currentUser {
            
            if user["password"] as! String == pass {
                
                DataView.sharedInstance.verified = .valid
            } else {
                DataView.sharedInstance.verified = .invalid
            }
        }
    }
}
