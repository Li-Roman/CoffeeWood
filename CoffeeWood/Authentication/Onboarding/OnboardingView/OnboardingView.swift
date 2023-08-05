//
//  OnboardingView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 18.07.2023.
//

import Foundation
import UIKit
import SnapKit
import CHIPageControl

protocol OnboardingViewDelegate: AnyObject {
    func didTappedNextButton()
}

class OnboardingView: UIView {
    
    weak var delegate: OnboardingViewDelegate?
    
    private var numberOfPages = 5
    private let nextButton = CircleNextButton()
    private let mainLabel = MainLabel()
    private let subLabel = SubLabel()
    private let mainImage = UIImageView()
    private let pageControl = CHIPageControlPaprika()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("OnboardingView is dead")
    }

    //MARK: - Internal Methods
    func setupNumberOfPages(for count: Int) {
        numberOfPages = count
    }
}

// MARK: - Setup Views
extension OnboardingView {
    private func setupViews() {
        backgroundColor = .systemBackground

        setupMainImage()
        setupMainLabel()
        setupSublabel()
        setupPageControl()
        setupNextButton()
    }
    
    private func setupMainImage() {
        setupMainImageConstraints()
        
        mainImage.image = UIImage(named: "СoffeeMachine")!
        mainImage.contentMode = .scaleAspectFit
    }
    
    private func setupMainImageConstraints() {
        addSubview(mainImage)
        mainImage.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().inset(145)
            maker.height.equalTo(300)
        }
    }
    
    private func setupMainLabel() {
        mainLabelConstraint()
        
        let mainLabelText = "Making your days with our coffee."
        mainLabel.makeMeOnbording(with: mainLabelText)
    }
    
    private func mainLabelConstraint() {
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(52)
            maker.top.equalTo(mainImage.snp_bottomMargin).inset(-24)
            maker.height.equalTo(80)
        }
    }
    
    private func setupSublabel() {
        subLabelConstraints()
        
        let subLabelText = "The best grain, the finest roast, the most powerful flavor."
        subLabel.makeMeOnbording(with: subLabelText)
    }
    
    private func subLabelConstraints() {
        addSubview(subLabel)
        subLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(60)
            maker.top.equalTo(mainLabel.snp_bottomMargin).inset(-20)
            maker.height.equalTo(50)
        }
    }
    
    private func setupPageControl() {
        pageControlConstraint()
        
        pageControl.numberOfPages = numberOfPages
        pageControl.progress = 0
        pageControl.radius = 6
        pageControl.padding = 12
        pageControl.tintColor = AppColors.PageControl.gray
        pageControl.currentPageTintColor = AppColors.PageControl.blue
        pageControl.enableTouchEvents = true
        pageControl.delegate = self
    }
    
    private func pageControlConstraint() {
        addSubview(pageControl)
        pageControl.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(50)
            maker.top.equalTo(subLabel.snp_bottomMargin).inset(-24)
            maker.height.equalTo(40)
        }
    }
    
    private func setupNextButton() {
        nextButtonConstraints()
        nextButton.setupButtonImage(size: 20)
        nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func nextButtonConstraints() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { maker in
            maker.height.width.equalTo(68)
            maker.right.equalToSuperview().inset(48)
            maker.bottom.equalToSuperview().inset(48)
        }
    }
}

// MARK: - Actions
extension OnboardingView {
    @objc private func nextButtonAction(sender: UIButton) {
        delegate?.didTappedNextButton()
    }
}

// MARK: - CHIBasePageControlDelegate
extension OnboardingView: CHIBasePageControlDelegate {
    func didTouch(pager: CHIBasePageControl, index: Int) {
        pageControl.set(progress: index, animated: true)
    }
}
