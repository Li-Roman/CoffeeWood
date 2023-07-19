//
//  LoginViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    var output: LoginOutputDelegate?
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        loginView.delegate = self
    }
    
}


// MARK: - Private Methods
extension LoginViewController {
    
    private func setupNavBar() {
        let image = UIImage(systemName: "arrow.left")?.withTintColor(.AppColors.nextButtonBlue)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonAction(sender:)))
        navigationItem.leftBarButtonItem = button
    }
    
    @objc
    private func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    
    func nextButtonDidTapped() {
        output?.nextButtonDidTapped()
    }
    
    func recoveryButtonDidTapped() {
        output?.recoveryButtonDidTapped()
    }
    
    func registerButtonDidTapped() {
        output?.registerButtonDidTapped()
    }

}

// MARK: - LoginInputDelegate
extension LoginViewController: LoginInputDelegate {
    
    func pushRecoveryVC() {
        print("Push Recovery VC")
    }
    
    func pushRegisterVC() {
        print("Push Register VC")
        let registerVC = RegisterModuleAssembly.configureModule()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func openHomePageVC() {
        print("Open Home Page VC")
    }
    
}
