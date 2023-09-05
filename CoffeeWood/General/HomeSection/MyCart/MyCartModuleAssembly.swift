import Foundation
import UIKit

class MyCartModuleAssembly {
    class func configureMoule() -> UIViewController {
        let presenter = MyCartPresenter()
        let viewController = MyCartController(delegate: presenter)
        
        return viewController
    }
}
