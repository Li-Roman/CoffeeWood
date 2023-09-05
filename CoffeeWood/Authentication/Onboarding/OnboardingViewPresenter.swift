import Foundation

class OnboardingViewPresenter {
    
    weak var viewController: OnboardingControllerInterface?
    
    deinit {
        print("OnboardingViewPresenter is dead")
    }
}

// MARK: - OnboardingControllerDelegate
extension OnboardingViewPresenter: OnboardingControllerDelegate {
    func willShowLoginController() {
        viewController?.pushLoginController()
    }
}
