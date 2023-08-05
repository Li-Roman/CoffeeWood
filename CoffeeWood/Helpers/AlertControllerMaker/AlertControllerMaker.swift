//
//  AlertControllerMaker.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 03.08.2023.
//

import Foundation
import UIKit

final class AlertControllerMaker {
    /// This method returns UIAlertController with needed title and message, this alert have only okAction for which you can set handler
    static func makeDefaultAlert(_ title: String, _ message: String, _ okTitile: String, style: UIAlertController.Style,
                                 handler forOkAction: ((UIAlertAction) -> Void)?) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: forOkAction)
        alertController.addAction(okAction)

        return alertController
    }
    
    static func makeAlertWithCancel(_ alertTitle: String, _ alertMessage: String, style: UIAlertController.Style,
                                    _ okTitle: String? = "Ok", _ cancelTitle: String? = "Cancel",
                                    handler forOkAction: ((UIAlertAction) -> Void)?,
                                    handler forCancelAction: ((UIAlertAction) -> Void)? ) -> UIAlertController {
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: forOkAction)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: forCancelAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        return alertController
    }
    
}
