//
//  ResetPasswordView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol ResetPasswordViewDelegate: AnyObject {
    func nextButtonDidTapped(with email: String?)
    func didRightSwipeAction()
}

class ResetPasswordView: UIView {
    
    weak var delegate: ResetPasswordViewDelegate?
    
    private let mainLabel = MainLabel()
    private let subLabel = SubLabel()
    private let nextButton = CircleNextButton()
    private let emailTextField = AuthViewWithTextField(.email, .done)
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    private func setupGestureRecognizers() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tap)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
    }
}

// MARK: - Internal Methods
extension ResetPasswordView {
    func toggleEnableNextButton() {
        nextButton.isEnabled = !nextButton.isEnabled
        
        switch nextButton.isEnabled {
        case true:
            nextButton.alpha = 1
        case false:
            nextButton.alpha = 0.5
        }
    }
}

//MARK: - Setup View
extension ResetPasswordView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupMainLabel()
        setupSubLabel()
        setupEmailTextField()
        setupNextButton()
    }
    
    private func setupMainLabel() {
        mainLabelConstraints()
        
        mainLabel.text = "Forgot Password?"
        mainLabel.font = UIFont(name: "Poppins-Medium", size: 24)
        mainLabel.textAlignment = .left
    }
    
    private func mainLabelConstraints() {
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(40)
            maker.top.equalToSuperview().inset(130)
            maker.height.equalTo(40)
        }
    }
    
    private func setupSubLabel() {
        subLabelConstraint()
        
        subLabel.text = "Enter your email address"
        subLabel.font = UIFont(name: "Poppins-Regular", size: 15)
        subLabel.textAlignment = .left
    }
    
    private func subLabelConstraint() {
        addSubview(subLabel)
        subLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(40)
            maker.top.equalTo(mainLabel).inset(44)
            maker.height.equalTo(40)
        }
    }
    
    private func setupEmailTextField() {
        emailTextFieldConstraints()
    }
    
    private func emailTextFieldConstraints() {
        addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp_bottomMargin).offset(40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }
    
    private func setupNextButton() {
        nextButtonConstraints()
        
        nextButton.addTarget(self, action: #selector(nextButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func nextButtonConstraints() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { maker in
            maker.height.width.equalTo(68)
            maker.right.equalToSuperview().inset(48)
            maker.top.equalTo(emailTextField).inset(200)
        }
    }
}

// MARK: - Actions
extension ResetPasswordView {
    @objc private func nextButtonAction(sender: UIButton) {
        delegate?.nextButtonDidTapped(with: emailTextField.getTextFieldText())
    }
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    @objc func rightSwipeAction() {
        delegate?.didRightSwipeAction()
    }
}

//MARK: - UITextFieldDelegate
extension ResetPasswordView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField.getTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
}
