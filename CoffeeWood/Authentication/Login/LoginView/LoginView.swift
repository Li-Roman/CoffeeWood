//
//  LoginView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol LoginViewDelegate: AnyObject {
    func didTappedNextButton(email: String?, password: String?)
    func didTappedResetButton()
    func didTappedRegistrationButton()
    func didRightSwipeAction()
}

class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?

    private let signInLabel = UILabel()
    private let signInSubLabel = UILabel()
    private let newMemberLabel = UILabel()
    private let emailTextField = AuthViewWithTextField(.email, .next)
    private let passwordTextField = AuthViewWithTextField(.password, .done)
    private let resetPasswordButton = UIButton()
    private let nextButton = CircleNextButton()
    private let registerButton = UIButton()
    private let secureButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGestureRecognizers()
    }
    
    deinit {
        print("LoginView is dead")
    }
    
    // MARK: - Internal Methods
    func clearPasswordTextFiled() {
        passwordTextField.clearTextFiledText()
    }
    
    func clearEmailTextField() {
        emailTextField.clearTextFiledText()
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

// MARK: - Setup Views
extension LoginView {
    private func setupViews() {
        backgroundColor = .systemBackground
        
        setupSignInLabel()
        setupSignInSubLabel()
        setupNewMemberLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupResetPasswordButton()
        setupNextButton()
        setupRegisterButton()
        setupSecureButton()
    }
    
    private func setupSignInLabel() {
        signInLabelConstraints()
        
        signInLabel.text = "Sign in"
        signInLabel.textAlignment = .left
        signInLabel.font = UIFont(name: "Poppins-Medium", size: 24)!
        signInLabel.textColor = .AppColor.mainLabels
    }
    
    private func signInLabelConstraints() {
        addSubview(signInLabel)
        signInLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(130)
            make.height.equalTo(40)
        }
    }
    
    private func setupSignInSubLabel() {
        signInSubLabelConstraints()
        
        signInSubLabel.text = "Welcome back"
        signInSubLabel.textAlignment = .left
        signInSubLabel.font = UIFont(name: "Poppins-Regular", size: 15)
        signInSubLabel.textColor = .AppColor.subtitles
    }
    
    private func signInSubLabelConstraints() {
        addSubview(signInSubLabel)
        signInSubLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(signInLabel).inset(44)
            make.height.equalTo(40)
        }
    }
    
    private func setupNewMemberLabel() {
        newMemberLabelConstraints()
        
        newMemberLabel.text = "New member?"
        newMemberLabel.font = UIFont(name: "Poppins-Regular", size: 15)
        newMemberLabel.textAlignment = .left
        newMemberLabel.textColor = .AppColor.subtitles
    }
    
    private func newMemberLabelConstraints() {
        addSubview(newMemberLabel)
        newMemberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(80)
            make.width.equalTo(110)
            make.height.equalTo(30)
        }
    }
    
    private func setupEmailTextField() {
        emailTextFieldConstraints()
        
        emailTextField.setTextFieldDelegate(delegate: self)
    }
    
    private func emailTextFieldConstraints() {
        addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(signInSubLabel.snp_bottomMargin).inset(-40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }
    
    private func setupPasswordTextField() {
        passwordTextFieldConstraints()
        
        passwordTextField.setTextFieldDelegate(delegate: self)
    }
    
    private func passwordTextFieldConstraints() {
        addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp_bottomMargin).inset(-32)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }
    
    private func setupSecureButton() {
        secureButtonConstrainrs()
    
        secureButton.setBackgroundImage(UIImage(named: "Show"), for: .normal)
        secureButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        secureButton.imageView?.contentMode = .scaleAspectFit
        secureButton.layer.cornerRadius = 15
        secureButton.clipsToBounds = true
        secureButton.imageView?.clipsToBounds = true
        secureButton.addTarget(self, action: #selector(secureButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func secureButtonConstrainrs() {
        passwordTextField.addSubview(secureButton)
        secureButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
            maker.top.equalToSuperview().inset(10)
            maker.width.equalTo(20)
        }
    }
    
    private func setupResetPasswordButton() {
        resetPasswordButtonConstraints()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Poppins-Medium", size: 15)!,
            .foregroundColor: UIColor.AppColor.textButtons,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "Forgot Password?", attributes: attributes)
        resetPasswordButton.setAttributedTitle(attributedTitle, for: .normal)
        resetPasswordButton.addTarget(self, action: #selector(recoveryButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func resetPasswordButtonConstraints() {
        addSubview(resetPasswordButton)
        resetPasswordButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(passwordTextField.snp_bottomMargin).inset(-30)
            maker.height.equalTo(30)
            maker.width.equalTo(300)
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
            maker.bottom.equalToSuperview().inset(240)
        }
    }
    
    private func setupRegisterButton() {
        registerButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont(name: "Poppins-Medium", size: 15)!
        registerButton.configuration = .borderless()
        registerButton.configuration?.attributedTitle = AttributedString("Sign up", attributes: container)
        registerButton.configuration?.baseForegroundColor = .AppColor.nextButtonBlue
        registerButton.addTarget(self, action: #selector(registerButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func registerButtonConstraints() {
        addSubview(registerButton)
        registerButton.snp.makeConstraints { maker in
            maker.top.bottom.equalTo(newMemberLabel)
            maker.left.equalTo(newMemberLabel.snp_rightMargin).inset(4)
            maker.width.equalTo(90)
        }
    }
}

// MARK: - Actions
extension LoginView {
    @objc private func recoveryButtonAction(sender: UIButton) {
        delegate?.didTappedResetButton()
    }
    
    @objc private func nextButtonAction(sender: UIButton) {
        delegate?.didTappedNextButton(email: emailTextField.getTextFieldText(),
                                      password: passwordTextField.getTextFieldText())
    }
    
    @objc private func registerButtonAction(sender: UIButton) {
        delegate?.didTappedRegistrationButton()
    }
    
    @objc private func secureButtonAction(sender: UIButton) {
        passwordTextField.toggleSecureTextField()
    }
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    @objc func rightSwipeAction() {
        delegate?.didRightSwipeAction()
    }
}

// MARK: - UITextFieldDelegate
extension LoginView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField.getTextField():
            passwordTextField.getTextField().becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
    
