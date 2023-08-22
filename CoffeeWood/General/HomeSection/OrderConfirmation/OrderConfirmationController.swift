//
//  OrderConfirmationController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol OrderConfirmationControllerDelegate: AnyObject {
    func willSetOrder()
}

protocol OrderConfirmationControllerInterface: AnyObject {
    func showAlert(_ alertController: UIAlertController)
}

class OrderConfirmationController: UIViewController {
    
    var delegate: OrderConfirmationControllerDelegate?
    
    private let orderConfirmationView = OrderConfirmationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        orderConfirmationView.delegate = self
        
        view.addSubview(orderConfirmationView)
        orderConfirmationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - OrderConfirmationViewDelegate
extension OrderConfirmationController: OrderConfirmationViewDelegate {
    func didTappedPayNowButton() {
        print("didTappedPayNowButton in OrderConfirmationController")
        delegate?.willSetOrder()
    }
}

// MARK: - OrderConfirmationControllerInterface
extension OrderConfirmationController: OrderConfirmationControllerInterface {
    func showAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
}
