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
    
    private func logOut() {
        let alertTitleText = "Do yoy really wanna logOut?"
        let alertMessageText = ""
        let okTitleText = "LogOut"
        let cancelTitleText = "Cancel"
        let alertControllet = AlertControllerMaker.makeAlertWithCancel(alertTitleText,
                                                                       alertMessageText,
                                                                       style: .alert,
                                                                       okTitleText,
                                                                       cancelTitleText,
                                                                       handler: { [weak self] okAction in
            self?.viewController?.showOnboardingController()
            
            switch AuthService.shared.singOut() {
            case .success:
                self?.viewController?.showOnboardingController()
            case .failure(let error):
                let alertTitleText = "Something goes wrong!"
                let alertMessageText = "\(error.localizedDescription)"
                let okTitleText = "try again later"
                let alertController = AlertControllerMaker.makeDefaultAlert(alertTitleText,
                                                                            alertMessageText,
                                                                            okTitleText,
                                                                            style: .alert,
                                                                            handler: nil)
                self?.viewController?.showAlert(alertController)
            }
            
        }, handler: nil)
        viewController?.showAlert(alertControllet)
    }
}

// MARK: - UserProfileControllerDelegate
extension UserProfilePresenter: UserProfileControllerDelegate {
    func didChangeUserInfo(user: DDUser) {
        setUser(user: user)
    }
    
    func willShowOnbordingController() {
        logOut()
    }
}
