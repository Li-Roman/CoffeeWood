//
//  DatabaseService.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 23.07.2023.
//

import Foundation
import FirebaseFirestore

final class DatabaseService {
    
    static let shared = DatabaseService()
    private let database = Firestore.firestore()
    
    private var userRef: CollectionReference {
        database.collection("users")
    }
    
    private init() { }
    
    func setUser(user: DDUser, completion: @escaping (Result<DDUser, Error>) -> Void) {
        userRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        guard let uid = AuthService.shared.currentUser?.uid else { return }
        
        userRef.document(uid).getDocument { docSnapshot, error in
            guard let data = docSnapshot?.data() else { return }
            guard let name = data["name"] as? String,
                  let id = data["id"] as? String,
                  let email = data["email"] as? String,
                  let mobileNumber = data["mobileNumber"] as? String,
                  let address = data["address"] as? String else { return }
            
            let user = DDUser(id: id, name: name, email: email, mobileNumber: mobileNumber, address: address)
            completion(.success(user))
        }
    }
}
