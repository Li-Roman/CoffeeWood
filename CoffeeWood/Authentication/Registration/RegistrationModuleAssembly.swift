import Foundation
import UIKit

class RegistrationModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewController = RegistrationController()
        let presenter = RegistrationViewPresenter()
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
