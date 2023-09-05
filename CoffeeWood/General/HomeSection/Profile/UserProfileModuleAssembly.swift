import Foundation
import UIKit

class UserProfileModuleAssembly {
    class func configureModule(user: DDUser) -> UIViewController {
        let viewController = UserProfileController(user: user)
        let presenter = UserProfilePresenter()
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
