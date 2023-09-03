import Foundation
import UIKit

class HomeModuleAssembly {
    class func configureModule() -> UIViewController {
        let presenter = HomePresenter()
        let viewController = HomeController(delegate: presenter)

        return viewController
    }
}
