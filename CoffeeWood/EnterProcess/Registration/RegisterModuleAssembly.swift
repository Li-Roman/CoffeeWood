//
//  RegisterModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class RegisterModuleAssembly {
    
    class func configureModule() -> UIViewController {
        
        let view        = RegisterViewController()
        let presenter   = RegisterViewPresenter()
        
        view.output              = presenter
        presenter.viewController = view
        
        return view
    }
    
}
