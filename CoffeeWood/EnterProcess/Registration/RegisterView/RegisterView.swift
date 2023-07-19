//
//  RegisterView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class RegisterView: UIView {
    
    weak var delegate: RegisterViewDelegate?
    
    private let registerLabel    = UILabel()
    private let registerSubtitle = UILabel()
    private let userTextFiled    = UITextField()
    private let mobileTextFiled  = UITextField()
    private let emailTextField   = UITextField()
    private let psswrdTextField  = UITextField()
    private var stackView        = UIStackView()
    private let termsButton      = UIButton()
    private let nextButton       = NextButton()
    private let loginButton      = UIButton()
    private let loginBtnSubtitle = UILabel()
    
    
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
extension RegisterView {
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        setupRegisterLabel()
        setupRegisterSubtitle()
        setupStackView()
        setupTermsButton()
        setupNextButton()
        setupLoginButton()
        setupLoginBtnSubtitle()
    }
    
    private func setupRegisterLabel() {
        registerLabelConstraint()
        
        registerLabel.text            = "Sign up"
        registerLabel.textAlignment   = .left
        registerLabel.font            = .boldSystemFont(ofSize: 30)
        registerLabel.textColor       = .AppColors.mainLabels
    }
    
    private func registerLabelConstraint() {
        addSubview(registerLabel)
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            registerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            registerLabel.heightAnchor.constraint(equalToConstant: 40),
            registerLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupRegisterSubtitle() {
        registerSubtitleConstraints()
        
        registerSubtitle.text           = "Create an account here"
        registerSubtitle.textAlignment  = .left
        registerSubtitle.font           = UIFont.systemFont(ofSize: 16)
        registerSubtitle.textColor      = .AppColors.subtitles
    }
    
    private func registerSubtitleConstraints() {
        addSubview(registerSubtitle)
        registerSubtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registerSubtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            registerSubtitle.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 16),
            registerSubtitle.heightAnchor.constraint(equalToConstant: 30),
            registerSubtitle.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupTextFields() {
        
        [userTextFiled, mobileTextFiled, emailTextField, psswrdTextField].forEach {
            $0.delegate = self
            $0.borderStyle = .roundedRect
        }
        
        setupUserTextFiled()
        setupMobileTextFiled()
        setupEmailTextField()
        setupPsswrdTextField()
    }
    
    private func setupUserTextFiled() {
        userTextFiled.placeholder = "Username"
        userTextFiled.keyboardType = .default
        userTextFiled.clearButtonMode = .whileEditing
        userTextFiled.returnKeyType = .next
    }
    
    private func setupMobileTextFiled() {
        mobileTextFiled.placeholder = "Mobile Number"
        mobileTextFiled.keyboardType = .namePhonePad
        mobileTextFiled.returnKeyType = .next
        mobileTextFiled.clearButtonMode = .whileEditing
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = "Email address"
        emailTextField.keyboardType = .emailAddress
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.returnKeyType = .next
    }
    
    private func setupPsswrdTextField() {
        psswrdTextField.placeholder = "Password"
        psswrdTextField.keyboardType = .default
        psswrdTextField.clearButtonMode = .whileEditing
        psswrdTextField.returnKeyType = .done
    }
    
    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [userTextFiled, mobileTextFiled, emailTextField, psswrdTextField])
        setupTextFields()
        stackViewConstraints()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
    }
    
    private func stackViewConstraints() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: registerSubtitle.bottomAnchor, constant: 50),
            stackView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
    
    private func setupTermsButton() {
        termsButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        
        termsButton.configuration                        = .borderless()
        termsButton.configuration?.attributedTitle       = AttributedString("By signing up you agree with our Terms of Use", attributes: container)
        termsButton.configuration?.titleAlignment        = .center
        termsButton.configuration?.baseForegroundColor   = .AppColors.nextButtonBlue
    }
    
    private func termsButtonConstraints() {
        addSubview(termsButton)
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            termsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            termsButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            termsButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupNextButton() {
        nextButtonConstraints()
    }
    
    private func nextButtonConstraints() {
        addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 120),
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 180),
            nextButton.heightAnchor.constraint(equalToConstant: 64),
            nextButton.widthAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func setupLoginBtnSubtitle() {
        loginBtnSubtitleConstraints()
        
        loginBtnSubtitle.text             = "Already a member?"
        loginBtnSubtitle.textAlignment    = .left
        loginBtnSubtitle.font             = UIFont.systemFont(ofSize: 16)
        loginBtnSubtitle.textColor        = .AppColors.subtitles
    }
    
    private func loginBtnSubtitleConstraints() {
        addSubview(loginBtnSubtitle)
        loginBtnSubtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginBtnSubtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            loginBtnSubtitle.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            loginBtnSubtitle.heightAnchor.constraint(equalToConstant: 30),
            loginBtnSubtitle.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupLoginButton() {
        loginButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 16)
        
        loginButton.configuration                        = .borderless()
        loginButton.configuration?.attributedTitle       = AttributedString("Sign in", attributes: container)
        loginButton.configuration?.baseForegroundColor   = .AppColors.nextButtonBlue
        
        loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func loginButtonConstraints() {
        addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 8),
            loginButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            loginButton.heightAnchor.constraint(equalToConstant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}


// MARK: - Actions
extension RegisterView {
    
    @objc
    private func nextButtonAction(sender: UIButton) {
        print("Next Button Action")
    }
    
    @objc
    private func loginButtonAction(sender: UIButton) {
        print("Login Button Action")
    }
    
    @objc
    private func termsButtonAction(sender: UIButton) {
        print("Terms Button Action")
    }
    
}


// MARK: - UITextFieldDelegate
extension RegisterView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            
        case userTextFiled:
            mobileTextFiled.becomeFirstResponder()
        case mobileTextFiled:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            psswrdTextField.becomeFirstResponder()
            
        default: textField.resignFirstResponder()
        }
        return true
    }
    
}
    
