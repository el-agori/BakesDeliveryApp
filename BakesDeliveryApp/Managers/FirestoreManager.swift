//
//  FirestoreManager.swift
//  BakesDeliveryApp
//
//  Created by Haifa Zakaria on 21/12/2024.
//
import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager()
    
    private init() {}
    
    private var db = Firestore.firestore()

    func storePhoneNumber(phoneNumber: String, userName: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, NSError(domain: "FirestoreManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let userRef = db.collection("users").document(user.uid)
        
        userRef.setData([
            "name": userName,
            "phone_number": phoneNumber
        ], merge: true) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}
