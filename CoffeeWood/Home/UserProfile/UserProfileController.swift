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
}

protocol UserProfileControllerInterface: AnyObject {
    func showAlert(_ alertController: UIAlertController)
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
}

// MARK: - Setup Navigation Controller
extension UserProfileController {
    private func setupNavController() {
//        navigationController?.title = "Profile"
        self.title = "Profile"
        let image = UIImage(systemName: "arrow.left")?.withTintColor(.AppColor.nextButtonBlue)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(leftBarButtonAction(sender:)))
        navigationItem.leftBarButtonItem = button
    }
}

// MARK: - Actions
extension UserProfileController {
    @objc func leftBarButtonAction(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UserProfileInputDelegate
extension UserProfileController: UserProfileControllerInterface {
    func showAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func showHomeVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UserProfileViewDelegate
extension UserProfileController: UserProfileViewDelegate {
    func didChangeUserInfo(user: DDUser) {
        delegate?.didChangeUserInfo(user: user)
    }
}
