import Foundation
import UIKit

enum AuthResult {
    case success
    case failure(Error)
}

enum AuthError {
    case notFilled
    case invalideEmail
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill all spaces", comment: "")
        case .invalideEmail:
            return NSLocalizedString("Email is not valid", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown Error", comment: "")
        case .serverError:
            return NSLocalizedString("Server Error", comment: "")
        }
    }
}

final class AuthHelper {
    
    static let shared = AuthHelper()
    
    private init() { }
    
    /// This method is helping you to Sign In into firebase auth. Use this metho in SIgn In process
    func sighIn(email: String?, password: String?, completion: @escaping (AuthResult) -> Void) {
        guard isValidSignIn(email: email, password: password) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        AuthService.shared.signIn(email: email!, password: password!) { result in
            switch result {
            case .success(_):
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// This method is create new user in our After successful verification sms code
    func createUser(username: String, mobileNumber: String, email: String, password: String, completion: @escaping (AuthResult) -> Void) {
        AuthService.shared.singUp(username: username,
                                  mobileNumer: mobileNumber,
                                  email: email,
                                  password: password) { result  in
            switch result {
            case .success( let user):
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// This method helps you to verify input code in AuthService
    func verifySmsCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        AuthService.shared.verifyCode(smsCode: smsCode) { result in
            switch result {
            case true:
                completion(true)
            case false:
                completion(false)
            }
        }
    }
    
    /// This Method hepls you to validate  phoneNumber entered by user
    func verifMobileNumber(mobileNumber: String, completion: @escaping (Bool) -> Void) {
        AuthService.shared.verifyPhoneNumber(mobileNumber: mobileNumber) { result in
            switch result {
            case true:
                completion(true)
            case false:
                completion(false)
            }
        }
    }
    
    func resetPasswordFor(email: String?, completion: @escaping (AuthResult) -> Void) {
        guard let email = email, email.count > 0 else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        AuthService.shared.resetPassword(email: email) { AuthResult in
            switch AuthResult {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// This method helps you to validate inputs as usename, mobile number, email address and password
    func isValidSingUp(_ username: String?, _ mobileNumber: String?, _ email: String?, _ password: String?) -> Bool {
        guard isValidSignIn(email: email, password: password),
              let username = username,
              let mobileNumber = mobileNumber,
              username.count > 0,
              mobileNumber.count == 12 else {
            return false
        }
        return true
    }
    
    /// This method helps you to validate inputs as email address and password
    func isValidSignIn(email: String?, password: String?) -> Bool {
        guard let email = email,
              let password = password,
              email.count > 0,
              password.count > 0 else {
            return false
        }
        return true
    }
    
    /// This Method helps you to validate password input
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    /// This method helps you to validate lenght of input sms code
    func isValidSms(_ code: String?) -> Bool {
        guard let smsCode = code, smsCode.count == 6 else { return false }
        return true
    }
    
    /// This method returns you UIAlertController with input parametrs as title, message and handler for okAction
    func setupAlertController(title: String, message: String, handler forOkAction: ((UIAlertAction) -> Void)?) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: forOkAction)
        alertController.addAction(okAction)

        return alertController
    }
}
