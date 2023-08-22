//
//  VerificationViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 26.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol VerificationConrtollerDelegate: AnyObject {
    func nextButtonDidTapped(smsCode: String?)
}

protocol VerificationConrtollerInterface: AnyObject {
    func showHomeVC()
    func showAlertConrtoller(_ alertController: UIAlertController)
    func backToRegistrationController()
}

class VerificationController: UIViewController {
    
    var delegate: VerificationConrtollerDelegate?
    
    private let verificationView = VerificationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupView()
    }
    
    deinit {
        print("VerificationViewController is dead")
    }

    // MARK: - Private Methods
    private func setupView() {
        view.addSubview(verificationView)
        verificationView.delegate = self
        
        verificationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(AppColors.NavController.darkBlue)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonAction(sender:)))
        navigationItem.leftBarButtonItem = button
    }
}

// MARK: - Actions
extension VerificationController {
    @objc private func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - VerificationViewDelegate
extension VerificationController: VerificationViewDelegate {
    func didRightSwipeAction() {
        print("Right Swipe Action")
    }
    
    func didTappedNextButton(smsCode: String?) {
        print("Next Button did tapped in VerificationViewController with smscode = \(smsCode ?? "0")")
        delegate?.nextButtonDidTapped(smsCode: smsCode)
    }
}

// MARK: - VerificationConrtollerInterface
extension VerificationController: VerificationConrtollerInterface {
    func showHomeVC() {
        let tabbarController = GeneralTabBatController()
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabbarController)
    }
    
    func showAlertConrtoller(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func backToRegistrationController() {
        navigationController?.popViewController(animated: true)
    }
}
