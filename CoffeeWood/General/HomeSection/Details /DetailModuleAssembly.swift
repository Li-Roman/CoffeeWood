import Foundation
import UIKit

class DetailModuleAssembly {
    class func configureModule(_ coffeeProduct: CoffeeProduct) -> UIViewController {
        let viewController = DetailController(coffeeProduct)
        let presenter = DetailPresenter(coffeeProduct)
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
