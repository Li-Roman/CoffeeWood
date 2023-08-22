//
//  LoginViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol LoginControllerDelegate: AnyObject {
    func willShowHomePageConrtoller(_ email: String?, _ password: String?)
    func willPushResetPasswordVC()
    func willPushRegistrationConrtoller()
}

protocol LoginControllerInterface: AnyObject {
    func pushRegistrationConrtoller()
    func pushResetPasswordConrtoller()
    func showResetPasswordConrtoller()
    func showAlertController(_ alertController: UIAlertController)
    func clearPasswordTextField()
    func clearEmailTextField()
    func showTabbarController()
}

class LoginController: UIViewController {
    
    private let loginView = LoginView()
    
    var delegate: LoginControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupView()
    }
    
    deinit {
        print("LoginViewController is dead")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.addSubview(loginView)
        loginView.delegate = self
        
        loginView.snp.makeConstraints { make in
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
extension LoginController {
    @objc private func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - LoginViewDelegate
extension LoginController: LoginViewDelegate {
    func didTappedNextButton(email: String?, password: String?) {
        delegate?.willShowHomePageConrtoller(email, password)
    }
    
    func didTappedResetButton() {
        delegate?.willPushResetPasswordVC()
    }
    
    func didTappedRegistrationButton() {
        delegate?.willPushRegistrationConrtoller()
    }
    
    func didRightSwipeAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - LoginControllerInterface
extension LoginController: LoginControllerInterface {
    func showAlertController(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func pushResetPasswordConrtoller() {
        let resetVC = ResetPasswordModuleAssembly.configureModule()
        navigationController?.pushViewController(resetVC, animated: true)
    }
    
    func pushRegistrationConrtoller() {
        let registerVC = RegistrationModuleAssembly.configureModule()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func showTabbarController() {
        let tabbarController = GeneralTabBatController()
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabbarController)
    }
//    
//    func showTabbarController() {
//        let tabbarController = GeneralTabBatController()
//        tabbarController.modalTransitionStyle = .flipHorizontal
//        tabbarController.modalPresentationStyle = .fullScreen
//        present(tabbarController, animated: true)
//    }
    
    func showResetPasswordConrtoller() {
        let viewConrtoller = ResetPasswordModuleAssembly.configureModule()
        navigationController?.pushViewController(viewConrtoller, animated: true)
    }
    
    func clearPasswordTextField() {
        loginView.clearPasswordTextFiled()
    }
    
    func clearEmailTextField() {
        loginView.clearEmailTextField()
    }
}
