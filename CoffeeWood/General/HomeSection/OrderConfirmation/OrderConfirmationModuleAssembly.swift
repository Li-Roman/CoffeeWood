import Foundation
import UIKit

class OrderConfirmationModuleAssembly {
    class func configureModule() -> UIViewController {
        let presenter = OrderConfirmationPresenter()
        let viewController = OrderConfirmationController(delegate: presenter)

        return viewController
    }
}
