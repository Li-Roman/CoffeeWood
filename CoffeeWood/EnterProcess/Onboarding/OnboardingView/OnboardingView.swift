//
//  OnboardingView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import Foundation
import UIKit

class OnboardingView: UIView {
    
    weak var delegate: OnboardingViewDelegate?
    private let nextButton   = NextButton()
    private let welcomeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Setup Views
extension OnboardingView {
    
    private func setupViews() {
        backgroundColor = .systemBackground
        setupWelcomeLabel()
        setupNextButton()
    }
    
    private func setupWelcomeLabel() {
        welcomeLabelConstraints()
        
        welcomeLabel.text = "Making your days with our coffee."
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .boldSystemFont(ofSize: 24)
        welcomeLabel.textColor = .darkGray
        welcomeLabel.numberOfLines = 0
    }
    
    private func welcomeLabelConstraints() {
        addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupNextButton() {
        nextButtonConstraints()
        nextButton.setupButtonImage(size: 20)
        
        nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
        
    }
    
    
    private func nextButtonConstraints() {
        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 120),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 64),
            nextButton.widthAnchor.constraint(equalToConstant: 64)
        ])
    }
}

// MARK: - Actions
extension OnboardingView {
    
    @objc
    private func nextButtonAction(sender: UIButton) {
        delegate?.nextButtonDidTapped()
    }
    
}
