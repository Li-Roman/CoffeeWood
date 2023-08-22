//
//  HomeModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 06.08.2023.
//

import Foundation
import UIKit

class HomeModuleAssembly {
    class func configureModule() -> UIViewController {
        let presenter = HomePresenter()
        let viewController = HomeController(delegate: presenter)
        
//        viewController.delegate = presenter
//        presenter.viewController = viewController
        
        return viewController
    }
}
