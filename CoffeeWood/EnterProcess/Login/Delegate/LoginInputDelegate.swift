//
//  LoginInputDelegate.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation


protocol LoginInputDelegate: AnyObject {
    
    func pushRegisterVC()
    func pushRecoveryVC()
    func openHomePageVC()
    
}
