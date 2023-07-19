//
//  LoginViewDelegate.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation


protocol LoginViewDelegate: AnyObject {
    
    func nextButtonDidTapped()
    func recoveryButtonDidTapped()
    func registerButtonDidTapped()
    
}
