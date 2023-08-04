//
//  OnboardingViewAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import Foundation
import UIKit

class OnboardingModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewController = OnboardingController()
        let presenter = OnboardingViewPresenter()
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}


