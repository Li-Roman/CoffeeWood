//
//  LoginView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    private let signInLabel     = UILabel()
    private let signInSubtitle  = UILabel()
    private let newMemberLabel  = UILabel()
    private let emailTextField  = UITextField()
    private let psswrdTextField = UITextField()
    private let recoveryButton  = UIButton()
    private let nextButton      = NextButton()
    private let registerButton  = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
}


// MARK: - Setup Views
extension LoginView {
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        setupSignInLabel()
        setupSignInSubtitle()
        setupNewMemberLabel()
        setupEmailTextField()
        setupPsswrdTextField()
        setupRecoveryButton()
        setupNextButton()
        setupRegisterButton()
    }
    
    private func setupSignInLabel() {
        signInLabelConstraints()
        
        signInLabel.text            = "Sign in"
        signInLabel.textAlignment   = .left
        signInLabel.font            = .boldSystemFont(ofSize: 30)
        signInLabel.textColor       = .AppColors.mainLabels
    }
    
    private func signInLabelConstraints() {
        addSubview(signInLabel)
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            signInLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            signInLabel.heightAnchor.constraint(equalToConstant: 40),
            signInLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupSignInSubtitle() {
        signInSubtitleConstraints()
        
        signInSubtitle.text           = "Welcome back"
        signInSubtitle.textAlignment  = .left
        signInSubtitle.font           = UIFont.systemFont(ofSize: 16)
        signInSubtitle.textColor      = .AppColors.subtitles
    }
    
    private func signInSubtitleConstraints() {
        addSubview(signInSubtitle)
        signInSubtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInSubtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            signInSubtitle.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 16),
            signInSubtitle.heightAnchor.constraint(equalToConstant: 30),
            signInSubtitle.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupNewMemberLabel() {
        newMemberLabelConstraints()
        
        newMemberLabel.text             = "New member?"
        newMemberLabel.textAlignment    = .left
        newMemberLabel.font             = UIFont.systemFont(ofSize: 16)
        newMemberLabel.textColor        = .AppColors.subtitles
    }
    
    private func newMemberLabelConstraints() {
        addSubview(newMemberLabel)
        newMemberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newMemberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            newMemberLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            newMemberLabel.heightAnchor.constraint(equalToConstant: 30),
            newMemberLabel.widthAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func setupEmailTextField() {
        emailTextFieldConstraints()
        
        emailTextField.delegate             = self
        emailTextField.placeholder          = "Email address"
        emailTextField.borderStyle          = .roundedRect
        emailTextField.clearsOnBeginEditing = true
        emailTextField.keyboardType         = .emailAddress
        emailTextField.returnKeyType        = .next
        emailTextField.clearButtonMode      = .whileEditing
    }
    
    private func emailTextFieldConstraints() {
        addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            emailTextField.topAnchor.constraint(equalTo: signInSubtitle.bottomAnchor, constant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupPsswrdTextField() {
        psswrdTextFieldConstraints()
        
        psswrdTextField.delegate             = self
        psswrdTextField.placeholder          = "Password"
        psswrdTextField.borderStyle          = .roundedRect
        psswrdTextField.clearsOnBeginEditing = true
        psswrdTextField.isSecureTextEntry    = true
        psswrdTextField.keyboardType         = .default
        psswrdTextField.returnKeyType        = .done
        psswrdTextField.clearButtonMode      = .whileEditing
    }
    
    private func psswrdTextFieldConstraints() {
        addSubview(psswrdTextField)
        psswrdTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            psswrdTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            psswrdTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            psswrdTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            psswrdTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupRecoveryButton() {
        recoveryButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 16)
        
        recoveryButton.configuration                        = .borderless()
        recoveryButton.configuration?.attributedTitle       = AttributedString("Forgot Password?", attributes: container)
        recoveryButton.configuration?.titleAlignment        = .center
        recoveryButton.configuration?.baseForegroundColor   = .AppColors.nextButtonBlue
        
        recoveryButton.addTarget(self, action: #selector(recoveryButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func recoveryButtonConstraints() {
        addSubview(recoveryButton)
        recoveryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recoveryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recoveryButton.topAnchor.constraint(equalTo: psswrdTextField.bottomAnchor, constant: 16),
            recoveryButton.heightAnchor.constraint(equalToConstant: 30),
            recoveryButton.widthAnchor.constraint(equalToConstant: 300)
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
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 160),
            nextButton.heightAnchor.constraint(equalToConstant: 64),
            nextButton.widthAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func setupRegisterButton() {
        registerButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 16)
        
        registerButton.configuration                        = .borderless()
        registerButton.configuration?.attributedTitle       = AttributedString("Sign up", attributes: container)
        registerButton.configuration?.baseForegroundColor   = .AppColors.nextButtonBlue
        registerButton.addTarget(self, action: #selector(registerButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func registerButtonConstraints() {
        addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: newMemberLabel.topAnchor),
            registerButton.bottomAnchor.constraint(equalTo: newMemberLabel.bottomAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 80),
            registerButton.leadingAnchor.constraint(equalTo: newMemberLabel.trailingAnchor, constant: -10)
        ])
    }

}


// MARK: - Actions
extension LoginView {
    
    @objc private func recoveryButtonAction(sender: UIButton) {
        print("Recovery Button Action")
        delegate?.recoveryButtonDidTapped()
    }
    
    @objc private func nextButtonAction(sender: UIButton) {
        print("Next Button Action")
        delegate?.nextButtonDidTapped()
    }
    
    @objc private func registerButtonAction(sender: UIButton) {
        print("Register Button Action")
        delegate?.registerButtonDidTapped()
    }

}


// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            psswrdTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}
    
