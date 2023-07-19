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
        
        let view = OnboardingViewController()
        
        let presenter = OnboardingViewPresenter()
        
        view.output = presenter
        presenter.viewController = view
        
        print("Configure Module")
        return view
    }
}


