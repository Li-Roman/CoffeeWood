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
        
        let view = LoginViewController()
        
        let presenter = LoginViewPresenter()
        
        view.output = presenter
        presenter.viewController = view
        
        print(" Login Module Assembly ")
        return view
    }
    
    
}

