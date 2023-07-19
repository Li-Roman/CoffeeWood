//
//  LoginViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation

class LoginViewPresenter {
    
    weak var viewController: LoginViewController?
    
}

// MARK: - LoginOutputDelegate
extension LoginViewPresenter: LoginOutputDelegate {
    
    func nextButtonDidTapped() {
        viewController?.openHomePageVC()
    }
    
    func recoveryButtonDidTapped() {
        viewController?.pushRecoveryVC()
    }
    
    func registerButtonDidTapped() {
        viewController?.pushRegisterVC()
        
    }
    
}
