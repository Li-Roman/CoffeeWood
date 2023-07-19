//
//  RegisterViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation


class RegisterViewPresenter {
    
    weak var viewController: RegisterInputDelegate?
    
}


extension RegisterViewPresenter: RegisterOutputDelegate {
    
    func loginButtonDidTaped() {
        viewController?.pushToVerificationVC()
    }
    
    func nextButtonDidTapped() {
        viewController?.popToLoginVC()
    }
    
    func termsButtonDidTapped() {
        viewController?.showTermsVC()
    }
    
}
