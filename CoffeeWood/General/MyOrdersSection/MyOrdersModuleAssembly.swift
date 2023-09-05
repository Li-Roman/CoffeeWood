import Foundation
import UIKit

class MyOrdersModuleAssembly {
    class func configureModule() -> UIViewController {
        let presenter = MyOrdersPresenter()
        let viewController = MyOrdersController(delegate: presenter)

        return viewController
    }
}
