//
//  OnboardingView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import Foundation
import UIKit
import CHIPageControl

class OnboardingView: UIView {
    
    weak var delegate: OnboardingViewDelegate?
    
    private var numberOfPages   = 5
    private let nextButton      = NextButton()
    private let welcomeTitle    = UILabel()
    private let welcomeSubtitle = UILabel()
    private let mainImage       = UIImageView()
    private let titlesControl   = CHIPageControlPaprika()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

//MARK: - Internal Methods
extension OnboardingView {
    
    func setupNumberOfPages(for count: Int) {
        numberOfPages = count
    }
    
}

// MARK: - Setup Views
extension OnboardingView {
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        seupMainImage()
        setupWelcomeTitle()
        setupWelcomeSubtitle()
        setupTitlesControl()
        setupNextButton()
    }
    
    private func seupMainImage() {
        setupseupMainImageConstraints()
        
        mainImage.image       = UIImage(named: "СoffeeMachine")!
        mainImage.contentMode = .scaleAspectFit
    }
    
    private func setupseupMainImageConstraints() {
        addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            mainImage.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupWelcomeTitle() {
        welcomeTitleConstraints()
        
        welcomeTitle.text           = "Making your days with our coffee."
        welcomeTitle.textAlignment  = .center
        welcomeTitle.numberOfLines  = 2
        welcomeTitle.font           = .systemFont(ofSize: 26)
        welcomeTitle.textColor      = .AppColors.mainLabels
    }
    
    private func welcomeTitleConstraints() {
        addSubview(welcomeTitle)
        welcomeTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            welcomeTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            welcomeTitle.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 24),
            welcomeTitle.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupWelcomeSubtitle() {
        welcomeSubtitleConstraints()
        
        welcomeSubtitle.text            = "The best grain, the finest roast, the most powerful flavor."
        welcomeSubtitle.textAlignment   = .center
        welcomeSubtitle.numberOfLines   = 2
        welcomeSubtitle.font            = .systemFont(ofSize: 16)
        welcomeSubtitle.textColor       = .AppColors.subtitles
    }
    
    private func welcomeSubtitleConstraints() {
        addSubview(welcomeSubtitle)
        welcomeSubtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeSubtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            welcomeSubtitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            welcomeSubtitle.topAnchor.constraint(equalTo: welcomeTitle.bottomAnchor, constant: 24),
            welcomeSubtitle.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTitlesControl() {
        titlesControlConstraint()
        
        titlesControl.numberOfPages         = numberOfPages
        titlesControl.progress              = 0
        titlesControl.radius                = 6
        titlesControl.padding               = 12
        titlesControl.tintColor             = .AppColors.subtitles
        titlesControl.currentPageTintColor  = .AppColors.nextButtonBlue
        titlesControl.enableTouchEvents     = true
        titlesControl.delegate              = self
    }
    
    private func titlesControlConstraint() {
        addSubview(titlesControl)
        titlesControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titlesControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            titlesControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            titlesControl.topAnchor.constraint(equalTo: welcomeSubtitle.bottomAnchor, constant: 16),
            titlesControl.heightAnchor.constraint(equalToConstant: 40)
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
// MARK: - CHIBasePageControlDelegate
extension OnboardingView: CHIBasePageControlDelegate {
    func didTouch(pager: CHIBasePageControl, index: Int) {
        titlesControl.set(progress: index, animated: true)
    }
}
