//
//  MyCartModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 17.08.2023.
//

import Foundation
import UIKit

class MyCartModuleAssembly {
    class func configureMoule() -> UIViewController {
//        let viewController = MyCartController()
//        let presenter = MyCartPresenter()
//
//        viewController.delegate = presenter
//        presenter.viewController = viewController
//
//        return viewController
        
        let presenter = MyCartPresenter()
        let viewController = MyCartController(delegate: presenter)
        
        return viewController
    }
}
