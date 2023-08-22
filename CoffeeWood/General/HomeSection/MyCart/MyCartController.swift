//
//  MyCartController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 17.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol MyCartControllerDelegate: AnyObject {
    var viewController: MyCartControllerInterface? { get set }
    
    func willShowCartPositions()
    func deletePosition(at index: Int)
    func willPopToPrevController()
    func willShowOrederConfirmationController()
}

protocol MyCartControllerInterface: AnyObject {
    func presentCartPositions(_ positions: [CartPosition])
    func showOrderConfirmationController(for order: Order)
    func showPrevController()
    func showAlert(_ alertController: UIAlertController)
}

class MyCartController: UIViewController {
    
    var delegate: MyCartControllerDelegate?
    
    private var myCartView: MyCartView?
    
    init(delegate: MyCartControllerDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.willShowCartPositions()
    }
    
    deinit {
        print("MyCartController is dead")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        myCartView = MyCartView(delegate: self)
        delegate?.viewController = self
        
        guard let myCartView = myCartView else { return }
        view.addSubview(myCartView)
        myCartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - MyCartViewDelegate
extension MyCartController: MyCartViewDelegate {
    func didDeleteCell(at index: Int) {
        delegate?.deletePosition(at: index)
    }
    
    func didTappedCheckoutButton() {
        print("checkount button did tapped in MyCartController")
        delegate?.willShowOrederConfirmationController()
    }
    
    func willShowCartPositions() {
        print("Will show cart positions in MyCartController")
        delegate?.willShowCartPositions()
    }
    
    func didTappedBackArrowButton() {
        delegate?.willPopToPrevController()
    }
}

// MARK: - MyCartControllerInterface
extension MyCartController: MyCartControllerInterface {
    func presentCartPositions(_ positions: [CartPosition]) {
        myCartView?.presentCartPositions(positions)
    }
    
    func showPrevController() {
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(_ alertController: UIAlertController) {
        self.present(alertController, animated: true)
    }
    
    func showOrderConfirmationController(for order: Order) {
        let orderConfirmationController = OrderConfirmationModuleAssembly.configureModule(order: order)
        
        if let sheet = orderConfirmationController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in
                        return 660
                    }
                ]
            } else {
                sheet.detents = [.large()]
            }
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 30
        }
        present(orderConfirmationController, animated: true)
    }
}
