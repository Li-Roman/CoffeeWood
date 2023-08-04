//
//  VerificationViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 26.07.2023.
//

import Foundation
import UIKit

class VerificationViewPresenter {
    
    weak var viewConrtoller: VerificationConrtollerInterface?
    
    deinit {
        print("VerificationViewPresenter is dead")
    }

    // MARK: - Private Methods
    private func isValide(_ smsCode: String?) -> Bool {
        guard AuthHelper.shared.isValidSms(smsCode) else {
            viewConrtoller?.showAlertConrtoller(AuthHelper.shared.setupAlertController(title: "Failed registration",
                                                                                           message: "Fill all spaces",
                                                                                           handler: nil))
            return false
        }
        return true
    }
    
    private func verifySmsCode(_ smsCode: String) {
        AuthHelper.shared.verifySmsCode(smsCode: smsCode) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case true:
                self.createUser() { [weak self] result in
                    guard let self = self else { return }
                    self.checkCreationUser(with: result)
                }
            case false:
                self.viewConrtoller?.showAlertConrtoller(AuthHelper.shared.setupAlertController(title: "Wrong Code",
                                                                                                    message: "try again",
                                                                                                    handler: nil))
            }
        }
    }
    
    private func createUser(completion: @escaping (AuthResult) -> Void) {
        let username = UserDefaultsManager.shared.string(forKey: .usernameTextFieldText) ?? ""
        let email = UserDefaultsManager.shared.string(forKey: .emailTextFieldText) ?? ""
        let mobileNumber = UserDefaultsManager.shared.string(forKey: .mobileNumberTextFieldText) ?? ""
        let password = UserDefaultsManager.shared.string(forKey: .passwordTextFieldText) ?? ""
        
        AuthHelper.shared.createUser(username: username, mobileNumber: mobileNumber,
                                     email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func checkCreationUser(with result: AuthResult) {
        switch result {
        case .success:
            self.viewConrtoller?.showAlertConrtoller(AuthHelper.shared.setupAlertController(title: "Success registration",
                                                                                                message: "") { [weak self] action in
                
                self?.viewConrtoller?.showHomeVC()
                self?.clearUserDefaults()
            })
        case .failure(let error):
            self.viewConrtoller?.showAlertConrtoller(AuthHelper.shared.setupAlertController(title: "Failed registration",
                                                                                            message: "\(error.localizedDescription)") { [weak self] action in
                self?.viewConrtoller?.backToRegistrationController()
            })
        }
    }
    
    private func clearUserDefaults() {
        UserDefaultsManager.shared.remove(forKey: .mobileNumberTextFieldText)
        UserDefaultsManager.shared.remove(forKey: .passwordTextFieldText)
        UserDefaultsManager.shared.remove(forKey: .usernameTextFieldText)
    }
}

//MARK: - VerificationConrtollerDelegate
extension VerificationViewPresenter: VerificationConrtollerDelegate {
    func nextButtonDidTapped(smsCode: String?) {
        guard isValide(smsCode) else { return }
        verifySmsCode(smsCode!)
    }
}
