//
//  UserProfileModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 29.07.2023.
//

import Foundation
import UIKit

class UserProfileModuleAssembly {
    class func configureModule(user: DDUser) -> UIViewController {
        let viewController = UserProfileController(user: user)
        let presenter = UserProfilePresenter()
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
