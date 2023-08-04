//
//  ResetPasswordModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation
import UIKit

class ResetPasswordModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewConrtoller = ResetPasswordController()
        let presenter = ResetPasswordPresenter()
        
        viewConrtoller.delegate = presenter
        presenter.viewController = viewConrtoller
        
        return viewConrtoller
    }
}
