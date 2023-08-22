//
//  MyOrdersModuleAssembly.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.08.2023.
//

import Foundation
import UIKit

class MyOrdersModuleAssembly {
    class func configureModule() -> UIViewController {
        let presenter = MyOrdersPresenter()
        let viewController = MyOrdersController(delegate: presenter)
        
//        viewController.delegate = presenter
//        presenter.viewController = viewController
//
        return viewController
    }
}
