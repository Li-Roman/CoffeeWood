//
//  LoginViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import FirebaseAuth
import UIKit

class LoginViewPresenter {
    
    weak var viewController: LoginController?
    
    deinit {
        print("LoginViewPresenter is dead")
    }

    // MARK: - Private Methods
   private func signIn(_ email: String?, _ password: String?) {
       AuthHelper.shared.sighIn(email: email, password: password) { [weak self] result in
           guard let self = self else { return }
            switch result {
                
            case .success:
                UserDefaultsManager.shared.set(email, forkey: .emailTextFieldText)
                self.viewController?.showHomePageConrtoller()
                
            case .failure(let error):

                let err = error as NSError
                
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self.viewController?.showAlertController(self.setupAlertForWrongPassword())
                case AuthErrorCode.userNotFound.rawValue:
                    self.viewController?.showAlertController(self.setupAlertForMissUser())
                    UserDefaultsManager.shared.set(email, forkey: .emailTextFieldText)
                default:
                    self.viewController?.showAlertController(AlertControllerMaker.makeDefaultAlert("Something goes wrong",
                                                                                                   "\(error.localizedDescription)",
                                                                                                   "Ok",
                                                                                                   style: .alert,
                                                                                                   handler: nil))
                }
            }
        }
    }
    
    private func setupAlertForMissUser() -> UIAlertController {
        let alertTitle = "User Not found"
        let alertMessage = ""
        let okTitle = "Wanna to register?"
        let cancelTitle = "Try another email"
        
        let alertController = AlertControllerMaker.makeAlertWithCancel(alertTitle, alertMessage, style: .alert,
                                                                       okTitle, cancelTitle, handler: { okAction in
            self.viewController?.pushRegistrationConrtoller()
        }, handler: { cancelAction in
            self.viewController?.clearEmailTextField()
            self.viewController?.clearPasswordTextField()
        })
        return alertController
    }
    
    private func setupAlertForWrongPassword() -> UIAlertController {
        let alertTitle = "Wrong Password"
        let alertMessage = ""
        let okTitle = "Reset password?"
        let cancelTitle = "Try againg"
        
        let alertController = AlertControllerMaker.makeAlertWithCancel(alertTitle, alertMessage, style: .alert,
                                                                       okTitle, cancelTitle, handler: { okAction in
            self.viewController?.showResetPasswordConrtoller()
        }, handler: { cancelAction in
            self.viewController?.clearPasswordTextField()
        })
        return alertController
    }
}

// MARK: - LoginControllerDelegate
extension LoginViewPresenter: LoginControllerDelegate {
    func willShowHomePageConrtoller(_ email: String?, _ password: String?) {
        signIn(email, password)
    }
    
    func willPushResetPasswordVC() {
        viewController?.pushResetPasswordConrtoller()
    }
    
    func willPushRegistrationConrtoller() {
        viewController?.pushRegistrationConrtoller()
    }
}
