//
//  ResetPasswordPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation

class ResetPasswordPresenter {
    weak var viewController: ResetPasswordConrtollerInterface?
}

// MARK: - Private Methods
extension ResetPasswordPresenter {
    private func resetPasswordFor(for email: String?) {
        // TODO: make next button isEnable = false пока не сработал алерт контроллер, чтобы не было дублирующих сообщений
        self.viewController?.toggleNextButtonEnabling()
        
        AuthHelper.shared.resetPasswordFor(email: email) { [weak self] AuthResult in
            switch AuthResult {
            case .success:
                let title = "Success!"
                let message = "We send you email with password reset link"
                self?.viewController?.showAlertConrtoller(AuthHelper.shared.setupAlertController(title: title,
                                                                                                 message: message) { action in
                    self?.viewController?.popToLoginConrtoller()
                    self?.viewController?.toggleNextButtonEnabling()
                })
            case .failure(let error):
                let title = "Something goes wrong"
                let message = "\(error.localizedDescription)"
                self?.viewController?.showAlertConrtoller(AuthHelper.shared.setupAlertController(title: title,
                                                                                                 message: message) { action in
                    self?.viewController?.toggleNextButtonEnabling()
                })
            }
        }
    }
}

// MARK: - ResetPasswordConrtollerDelegate
extension ResetPasswordPresenter: ResetPasswordConrtollerDelegate {
    func willResetPassword(for email: String?) {
        resetPasswordFor(for: email)
    }
}
