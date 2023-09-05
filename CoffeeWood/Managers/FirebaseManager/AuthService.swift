import Foundation
import UIKit
import Firebase

final class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let datatbase = Firestore.firestore()
    private var verificationID: String?
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    private init() { }
    
    func isEmailFree(_ email: String, completion: @escaping (Result<[String]?, Error>) -> Void) {
        auth.fetchSignInMethods(forEmail: email) { (providers, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(providers))
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func singUp(username: String, mobileNumer: String, email: String, password: String, completion: @escaping (Result <DDUser, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                let ddUser = DDUser(id: result.user.uid,
                                    name: username,
                                    email: email,
                                    mobileNumber: mobileNumer,
                                    address: ""
                                 )
                
                DatabaseService.shared.setUser(user: ddUser) { resultDB in
                    switch resultDB {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (AuthResult) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success)
            }
        }
    }
    
    func verifyPhoneNumber(mobileNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(mobileNumber, uiDelegate: nil) { verificationID, error in
            if let verificationID = verificationID {
                self.verificationID = verificationID
                completion(true)
            } else if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
                return
            }
        }
    }
    
    func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: smsCode
        )
        
        auth.signIn(with: credential) { result, error in
            if let _ = result {
                completion(true)
            } else if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func singOut() -> AuthResult {
        do {
            try AuthService.shared.auth.signOut()
        } catch let signOutError as NSError {
            return .failure(signOutError)
        }
        return .success
    }
}
