//
//  UserProfileViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 29.07.2023.
//

import Foundation
import UIKit

protocol UserProfileControllerDelegate: AnyObject {
    func didChangeUserInfo(user: DDUser)
    func willShowOnbordingController()
}

protocol UserProfileControllerInterface: AnyObject {
    func showAlert(_ alertController: UIAlertController)
    func showOnboardingController()
    func showHomeVC()
}

class UserProfileController: UIViewController {
    
    var delegate: UserProfileControllerDelegate?
    
    private let userProfileView: UserProfileView
    private let ddUser: DDUser
    
    init(user: DDUser) {
        ddUser = user
        userProfileView = UserProfileView(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    deinit {
        print("UserProfileViewController is dead")
    }

    // MARK: - Setup View
    private func configureView() {
        userProfileView.delegate = self
        
        view.addSubview(userProfileView)
        userProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupNavController()
    }

    // MARK: - Setup Navigation Controller
    private func setupNavController() {
        self.title = "Profile"
        navigationController?.navigationBar.isHidden = false
        
        let arrowImage = UIImage(systemName: "arrow.left")!
        let backButton = UIBarButtonItem(image: arrowImage, style: .plain, target: self, action: #selector(leftBarButtonAction(sender:)))
        navigationItem.leftBarButtonItem = backButton
        
        
        let logOutImage = UIImage(systemName: "iphone.and.arrow.forward")!
        
        let logOutButton = UIBarButtonItem(image: logOutImage, style: .plain, target: self, action: #selector(logOutButtonAction(sender:)))
        navigationItem.rightBarButtonItem = logOutButton
    }
}

// MARK: - Actions
extension UserProfileController {
    @objc func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func logOutButtonAction(sender: UIBarButtonItem) {
        delegate?.willShowOnbordingController()
    }
}

// MARK: - UserProfileInputDelegate
extension UserProfileController: UserProfileControllerInterface {
    func showAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func showOnboardingController() {
        let onbordingController = OnboardingModuleAssembly.configureModule()
        let authNavigationController = UINavigationController(rootViewController: onbordingController)
//        authNavigationController.modalTransitionStyle = .flipHorizontal
//        authNavigationController.modalPresentationStyle = .fullScreen
//        present(authNavigationController, animated: true)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authNavigationController)
    }
    
//    func showHomePageConrtoller() {
//        let viewController = HomeController()
//        let navController = UINavigationController(rootViewController: viewController)
//
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navController)
//    }
    
    func showHomeVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UserProfileViewDelegate
extension UserProfileController: UserProfileViewDelegate {
    func didChangeUserInfo(user: DDUser) {
        delegate?.didChangeUserInfo(user: user)
    }
    
    func didLogoutButtonTapped() {
        delegate?.willShowOnbordingController()
    }
}
