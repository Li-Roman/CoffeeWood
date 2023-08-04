//
//  OnboardingViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

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
