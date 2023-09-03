import Foundation
import UIKit

class MapModuleAssembly {
    class func configureModule() -> UIViewController {
        let presenter = MapPresenter()
        let viewController = MapController(delegate: presenter)
        
        return viewController
    }
}
