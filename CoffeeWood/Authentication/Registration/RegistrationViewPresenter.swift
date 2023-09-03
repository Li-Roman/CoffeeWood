import Foundation
import UIKit

class RegistrationViewPresenter {
    
    weak var viewController: RegistrationControllerInterfacee?
    
    deinit {
        print("RegistrationViewPresenter is dead")
    }
    
    //MARK: - Private Methods
    private func signUp(_ username: String?, _ mobileNumber: String?, _ email: String?, _ password: String?) {
        guard isValidSingUp(username, mobileNumber, email, password) else {
            return
        }
        guard isValidPassword(password!) else {
            return
        }
        
        AuthService.shared.isEmailFree(email!) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let providers):
                if providers != nil {
                    
                    self.viewController?.showAlertController(alertController: self.setupAlertForUsesEmail())
                } else {
                    self.saveCurrentInputs(username!, mobileNumber!, email!, password!)
                    self.verifMobileNumber(mobileNumber!)
                }
            case .failure(let error):
                self.viewController?.showAlertController(alertController:
                                                            AuthHelper.shared.setupAlertController(
                                                                title: "Fail",
                                                                message: "\(error.localizedDescription)",
                                                                handler: nil
                                                            )
                )
            }
        }
    }
    
    private func isValidSingUp(_ username: String?,
                               _ mobileNumber: String?,
                               _ email: String?,
                               _ password: String?) -> Bool {
        guard AuthHelper.shared.isValidSingUp(username,
                                              mobileNumber,
                                              email,
                                              password) else {
            viewController?.showAlertController(alertController:
                                                    AuthHelper.shared.setupAlertController(
                                                        title: "Failed registration",
                                                        message: "fill all spaces",
                                                        handler: nil
                                                    )
            )
            return false
        }
        return true
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        guard AuthHelper.shared.isValidPassword(password) else {
            viewController?.showAlertController(alertController:
                                                    AuthHelper.shared.setupAlertController(
                                                        title: "Invalid password",
                                                        message: "Password must be at least 6 characters",
                                                        handler: nil
                                                    )
            )
            return false
        }
        return true
    }
    
    private func setupAlertForUsesEmail() -> UIAlertController {
        let alertTitle = "This email is already in use"
        let alertMessage = "Try to reset your password"
        let okTitle = "I want to reset password"
        let cancelTitle = "I'll try another email"
        
        let alertController = AlertControllerMaker.makeAlertWithCancel(alertTitle,
                                                                       alertMessage,
                                                                       style: .alert,
                                                                       okTitle,
                                                                       cancelTitle) { action in
            self.viewController?.pushResetPasswordVC()
        } handler: { action in
            self.viewController?.clearEmailTextFiled()
        }
        return alertController
    }
    
    private func saveCurrentInputs(_ username: String, _ mobileNumber: String, _ email: String, _ password: String) {
        UserDefaultsManager.shared.set(email, forkey: .emailTextFieldText)
        UserDefaultsManager.shared.set(mobileNumber, forkey: .mobileNumberTextFieldText)
        UserDefaultsManager.shared.set(password, forkey: .passwordTextFieldText)
        UserDefaultsManager.shared.set(username, forkey: .usernameTextFieldText)
    }
    
    private func verifMobileNumber(_ mobileNumber: String) {
        AuthHelper.shared.verifMobileNumber(mobileNumber: mobileNumber) { [weak self] result in
            switch result {
            case true:
                self?.viewController?.pushVerificationVC()
            case false:
                let title = "Failed registration"
                let message = "Cant send verificationCode to your number \(mobileNumber)"
                self?.viewController?.showAlertController(alertController:
                                                            AuthHelper.shared.setupAlertController(
                                                                title: title,
                                                                message: message,
                                                                handler: nil
                                                            )
                )
            }
        }
    }
}

// MARK: - RegistrationControllerDelegate
extension RegistrationViewPresenter: RegistrationControllerDelegate {
    func willShowVerificationVC(username: String?, mobileNumber: String?, email: String?, password: String?) {
        signUp(username, mobileNumber, email, password)
    }
    
    func willShowLoginVC() {
        viewController?.popToLoginVC()
    }
    
    func willShowTermsVC() {
        viewController?.showTermsVC()
    }
}
