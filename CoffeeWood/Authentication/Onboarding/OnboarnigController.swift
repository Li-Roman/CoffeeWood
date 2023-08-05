//
//  ViewController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import UIKit
import SnapKit

protocol OnboardingControllerDelegate: AnyObject {
    func willShowLoginController()
}

protocol OnboardingControllerInterface: AnyObject {
    func pushLoginController()
}

class OnboardingController: UIViewController {
    
    var delegate: OnboardingControllerDelegate?
    
    private let onboardingView = OnboardingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnbordingView()
    }
    
    deinit {
        print("OnboardingViewController is dead")
    }
    
    // MARK: - Private Methods
    private func configureOnbordingView() {
        view.addSubview(onboardingView)
        
        onboardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        onboardingView.delegate = self
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = AppColors.NavController.darkBlue
    }
}

// MARK: - OnboardingViewDelegate
extension OnboardingController: OnboardingViewDelegate {
    func didTappedNextButton() {
        delegate?.willShowLoginController()
    }
}

// MARK: - OnboardingControllerInterface
extension OnboardingController: OnboardingControllerInterface {
    func pushLoginController() {
        let nextVC = LoginModuleAssembly.configureModule()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
