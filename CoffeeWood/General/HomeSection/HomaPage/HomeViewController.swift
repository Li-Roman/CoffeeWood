//
//  HomeViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.07.2023.
//

import Foundation
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let nextButton = CircleNextButton()
    private let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        print("HomeViewController is dead")
    }
    
    // MARK: - Private Methods
    private func showLoginVC() {
        let viewController = OnboardingModuleAssembly.configureModule()
        let navController = UINavigationController(rootViewController: viewController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navController)
    }
    
    private func showAlert(_ error: Error) {
        let alertController = UIAlertController(title: "Failed log out", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

// MARK: - Setup View
extension HomeViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        setupNextButton()
        setupLogoutButton()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = AppColors.NavController.darkBlue
    }
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(100)
            make.bottom.equalToSuperview().inset(100)
            make.height.width.equalTo(64)
        }
        nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func setupLogoutButton() {
        logoutButton.configuration = .borderless()
        logoutButton.configuration?.image = UIImage(systemName: "iphone.and.arrow.forward")?.withTintColor(.blue)
        logoutButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.darkBlue
//        logoutButton.configuration?.baseForegroundColor = .AppColor.nextButtonBlue
        logoutButton.addTarget(self, action: #selector(logoutButtonAction(sender:)), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(100)
            make.height.width.equalTo(20)
        }
    }
}

// MARK: - Actions
extension HomeViewController {
    @objc private func nextButtonAction(sender: UIButton) {
        let _ = DatabaseService.shared.getUser { [weak self] result in
            switch result {
            case .success(let user):
                let viewController = UserProfileModuleAssembly.configureModule(user: user)
                self?.navigationController?.pushViewController(viewController, animated: true)
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    @objc private func logoutButtonAction(sender: UIButton) {
        switch AuthService.shared.singOut() {
        case .success:
            showLoginVC()
        case .failure(let error):
            showAlert(error)
        }
    }
}
