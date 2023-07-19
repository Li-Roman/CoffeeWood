//
//  RegisterInputDelegate.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation

protocol RegisterInputDelegate: AnyObject {
    
    func popToLoginVC()
    func pushToVerificationVC()
    func showTermsVC()
    
}
