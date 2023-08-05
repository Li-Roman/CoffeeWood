//
//  RegisterViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

protocol RegistrationControllerDelegate: AnyObject {
    func willShowVerificationVC(username: String?, mobileNumber: String?, email: String?, password: String?)
    func willShowTermsVC()
    func willShowLoginVC()
}

protocol RegistrationControllerInterfacee: AnyObject {
    func popToLoginVC()
    func pushVerificationVC()
    func showTermsVC()
    func pushResetPasswordVC()
    func clearEmailTextFiled()
    func showAlertController(alertController: UIAlertController)
}

class RegistrationController: UIViewController {
    
    var delegate: RegistrationControllerDelegate?
    
    private var registrationView = RegistrationView()
    
    override func loadView() {
        view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        registrationView.delegate = self
    }
    
    deinit {
        print("RegistrationViewController is dead")
    }

    //MARK: - Private Methods
    private func setupNavBar() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(AppColors.NavController.darkBlue)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonAction(sender:)))
        navigationItem.leftBarButtonItem = button
    }
}

//MARK: - Actions
extension RegistrationController {
    @objc private func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - RegistrationViewDelegate
extension RegistrationController: RegistrationViewDelegate {
    func nextButtonDidTapped(username: String?, mobileNumber: String?, email: String?, password: String?) {
        delegate?.willShowVerificationVC(username: username, mobileNumber: mobileNumber, email: email, password: password)
    }
    
    func termsButtonDidTapped() {
        delegate?.willShowTermsVC()
    }
    
    func loginButtonDidTapped() {
        delegate?.willShowLoginVC()
    }
}

// MARK: - RegistrationControllerInterfacee
extension RegistrationController: RegistrationControllerInterfacee {
    func pushVerificationVC() {
        navigationController?.pushViewController(VerificationModuleAssembly.configureModule(), animated: true)
    }
    
    func popToLoginVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func showTermsVC() {
        print("Terms and ConditionsVC")
    }
    
    func showAlertController(alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func pushResetPasswordVC() {
        let viewConrtoller = ResetPasswordModuleAssembly.configureModule()
        navigationController?.pushViewController(viewConrtoller, animated: true)
    }
    
    func clearEmailTextFiled() {
        registrationView.clearEmailTextFiledText()
    }
}
