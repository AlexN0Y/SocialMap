//
//  FirebaseManager.swift
//  RoadFeatures
//
//  Created by Alex Gav on 27.05.2023.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    private func addUserToFirestore(userId: String, userName: String, userEmail: String, completion: @escaping (Error?) -> Void) {
        let usersCollection = db.collection("users").document(userId)
        let userData: [String: Any] = [
            "name": userName,
            "email": userEmail
        ]
        usersCollection.setData(userData) { (error) in
            completion(error)
        }
    }
    
    func createUser(withEmail email: String, password: String, userName: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                self.addUserToFirestore(userId: authResult?.user.uid ?? "", userName: userName, userEmail: email, completion: completion)
            }
        }
    }
    
    func logIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(authResult, error)
        }
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func getUserDetails(uid: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let usersCollection = db.collection("users")
        let userDocument = usersCollection.document(uid)
        userDocument.getDocument { (document, error) in
            completion(document?.data(), error)
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func getDocuments(collection: String, completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        db.collection(collection).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else if let documents = querySnapshot?.documents {
                let data = documents.map { $0.data() }
                completion(data, nil)
            }
        }
    }
    
    func addDocument(collection: String, data: [String: Any], completion: @escaping (String?, Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection(collection).addDocument(data: data) { error in
            completion(ref?.documentID, error)
        }
    }
    
    func removeDocument(collection: String, documentID: String, completion: @escaping (Error?) -> Void) {
        db.collection(collection).document(documentID).delete() { error in
            completion(error)
        }
    }
    
    func setNewId(documentID: String, data: [String : Any]) {
        db.collection("points").document(documentID).setData(data)
    }
    
}

