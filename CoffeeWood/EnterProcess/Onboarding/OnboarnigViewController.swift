//
//  ViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let onboardingView = OnboardingView()
    var output: OnboardingOutputDelegate?
    
    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.delegate = self
    }

}

// MARK: - Private Methods
extension OnboardingViewController {
    
    private func setupNavigationController() {

        navigationController?.navigationBar.tintColor = .AppColors.mainLabels
        navigationItem.backButtonDisplayMode = .minimal
    }
}


// MARK: - OnboardingViewDelegate
extension OnboardingViewController: OnboardingViewDelegate {
    func nextButtonDidTapped() {
        output?.nextButtonDidTapped()
    }
}


// MARK: - OnboardingInputDelegate
extension OnboardingViewController: OnboardingInputDelegate {
    
    func pushNextVC() {
        setupNavigationController()
        let nextVC = LoginModuleAssembly.configureModule()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
