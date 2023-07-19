//
//  RegisterViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
    private var registerView = RegisterView()
    var output: RegisterOutputDelegate?
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        registerView.delegate = self
    }
    
}

//MARK: - Private Methods
extension RegisterViewController {
    
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


// MARK: - RegisterViewDelegate
extension RegisterViewController: RegisterViewDelegate {
    
    func nextButtonDidTapped() {
        output?.nextButtonDidTapped()
    }
    
    func termsButtonDidTapped() {
        output?.termsButtonDidTapped()
    }
    
    func loginButtonDidTapped() {
        output?.loginButtonDidTaped()
    }
    
}

// MARK: - RegisterInputDelegate
extension RegisterViewController: RegisterInputDelegate {
    
    func pushToVerificationVC() {
        // здесь переходим на экран верификации.
        // В иделе нам отправляется код на почту или на телефон, как сделаем, после чего мы его подвержаем
    }
    
    func popToLoginVC() {
        // Переходим на предыдущий экрна
    }
    
    func showTermsVC() {
        // Снизу вылезает экран с согласием на обработку данных АНБ
    }
    
}
