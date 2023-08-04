//
//  LoginModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class LoginModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewConrtoller = LoginController()
        let presenter = LoginViewPresenter()
        
        viewConrtoller.delegate = presenter
        presenter.viewController = viewConrtoller
        
        return viewConrtoller
    }
}

