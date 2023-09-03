import Foundation
import UIKit

class VerificationModuleAssembly {
    class func configureModule() -> UIViewController {
        let viewConrtoller = VerificationController()
        let presenter = VerificationViewPresenter()
        
        viewConrtoller.delegate = presenter
        presenter.viewConrtoller = viewConrtoller
        
        return viewConrtoller
    }
}
