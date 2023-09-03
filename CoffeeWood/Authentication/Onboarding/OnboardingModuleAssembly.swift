import Foundation
import UIKit

class OnboardingModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewController = OnboardingController()
        let presenter = OnboardingViewPresenter()
        
        viewController.delegate = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}


