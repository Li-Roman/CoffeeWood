//
//  OnboardingViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import Foundation


class OnboardingViewPresenter {
    
    weak var viewController: OnboardingViewController?
    
}

// MARK: - OnboardingOutputDelegate
extension OnboardingViewPresenter: OnboardingOutputDelegate {
    
    func nextButtonDidTapped() {
        viewController?.pushNextVC()
    }
    
}
