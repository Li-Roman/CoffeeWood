//
//  RegisterModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class RegistrationModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewController = RegistrationController()
        let presenter = RegistrationViewPresenter()
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
