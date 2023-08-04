//
//  UserProfilePresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 29.07.2023.
//

import Foundation
import UIKit

class UserProfilePresenter {
    weak var viewController: UserProfileControllerInterface?
    
    deinit {
        print("UserProfilePresenter is dead")
    }
    
    // MARK: - Private Methods
    private func setUser(user: DDUser) {
        DatabaseService.shared.setUser(user: user) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print("Fail \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UserProfileControllerDelegate
extension UserProfilePresenter: UserProfileControllerDelegate {
    func didChangeUserInfo(user: DDUser) {
        setUser(user: user)
    }
    
//    func getUser() -> DDUser? {
//        var ddUser: DDUser? = nil
//        if let _ = AuthService.shared.currentUser {
//            DatabaseService.shared.getUser { [weak self] result in
//                switch result {
//                case .success(let user):
//                    ddUser = user
//                case .failure(let error):
//                    self?.viewController?.showAlert(AuthHelper.helper.setupAlertController(title: "Something goes wrong",
//                                                                                           message: "\(error.localizedDescription)") { action in
//                        self?.viewController?.showHomeVC()
//                    })
//                }
//            }
//        }
//        print("ddUser != nil is \(ddUser != nil)")
//        return ddUser
//    }
}
