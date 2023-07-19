//
//  LoginOutputDelegate.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation


protocol LoginOutputDelegate: AnyObject {
    
    func nextButtonDidTapped()
    func recoveryButtonDidTapped()
    func registerButtonDidTapped()
    
}
