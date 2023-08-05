//
//  ResetPasswordViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol ResetPasswordConrtollerDelegate: AnyObject {
    func willResetPassword(for email: String?)
}

protocol ResetPasswordConrtollerInterface: AnyObject {
    func showAlertConrtoller(_ alertController: UIAlertController)
    func popToLoginConrtoller()
    func toggleNextButtonEnabling()
}

class ResetPasswordController: UIViewController {
    
    var delegate: ResetPasswordConrtollerDelegate?
    
    private let resetPasswordView = ResetPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
    }
    
    deinit {
        print("ResetPasswordController is dead")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.addSubview(resetPasswordView)
        resetPasswordView.delegate = self
        
        resetPasswordView.snp.makeConstraints { make in
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
extension ResetPasswordController {
    @objc private func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ResetPasswordInputDelegate
extension ResetPasswordController: ResetPasswordConrtollerInterface {
    func showAlertConrtoller(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func popToLoginConrtoller() {
        if let viewController = navigationController?.children[1] {
            navigationController?.popToViewController(viewController, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func toggleNextButtonEnabling() {
        resetPasswordView.toggleEnableNextButton()
    }
}

// MARK: - ResetPasswordViewDelegate
extension ResetPasswordController: ResetPasswordViewDelegate {
    func nextButtonDidTapped(with email: String?) {
        delegate?.willResetPassword(for: email)
    }
    
    func didRightSwipeAction() {
        navigationController?.popViewController(animated: true)
    }
}
