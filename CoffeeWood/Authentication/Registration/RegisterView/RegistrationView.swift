//
//  RegisterView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func nextButtonDidTapped(username: String?, mobileNumber: String?, email: String?, password: String?)
    func termsButtonDidTapped()
    func loginButtonDidTapped()
    func didRightSwipeAction()
}

class RegistrationView: UIView {
    
    weak var delegate: RegistrationViewDelegate?
    
    private let registerLabel = UILabel()
    private let registerSubLabel = UILabel()
    private let userTextFiled = AuthViewWithTextField(.username, .next)
    private let mobileTextFiled = AuthViewWithTextField(.mobileNumber, .next)
    private let emailTextField = AuthViewWithTextField(.email, .next)
    private let psswrdTextField = AuthViewWithTextField(.password, .done)
    private var stackView = UIStackView()
    private let termsButton = UIButton()
    private let nextButton = CircleNextButton()
    private let loginButton = UIButton()
    private let loginBtnSubtitle = UILabel()
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
        print("RegistrationView is dead")
    }
    
    // MARK: - Internal Methods
    func clearEmailTextFiledText() {
        emailTextField.clearTextFiledText()
        emailTextField.getTextField().becomeFirstResponder()
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
    
    private func mobileNumberFormatter(mask: String, mobileNumber: String) -> String {
        let number = mobileNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
    
    private func mobileNumberOutputFormat(_ mobileNumber: String?) -> String? {
        guard let mobileNumber = mobileNumber else { return "" }
        let allowChars = "+0123456789"
        let output = mobileNumber.filter { allowChars.contains($0)}
        print(output)
        return output
    }
}

// MARK: - Setup Views
extension RegistrationView {
    private func setupViews() {
        backgroundColor = .systemBackground
        
        setupRegisterLabel()
        setupRegisterSubLabel()
        setupStackView()
        setupTermsButton()
        setupNextButton()
        setupLoginButton()
        setupLoginBtnSubtitle()
        setupSecureButton()
    }
    
    private func setupRegisterLabel() {
        registerLabelConstraint()
        
        registerLabel.text = "Sign up"
        registerLabel.font = UIFont(name: "Poppins-Medium", size: 24)
        registerLabel.textAlignment = .left
        registerLabel.textColor = .AppColor.mainLabels
    }
    
    private func registerLabelConstraint() {
        addSubview(registerLabel)
        registerLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(130)
            make.height.equalTo(40)
        }
    }
    
    private func setupRegisterSubLabel() {
        registerSubLabelConstraints()
        
        registerSubLabel.text = "Create an account here"
        registerSubLabel.textAlignment = .left
        registerSubLabel.font = UIFont(name: "Poppins-Regular", size: 15)
        registerSubLabel.textColor = .AppColor.subtitles
    }
    
    private func registerSubLabelConstraints() {
        addSubview(registerSubLabel)
        registerSubLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(registerLabel).inset(44)
            make.height.equalTo(40)
        }
    }
    
    private func setupTextFields() {
        [userTextFiled, mobileTextFiled, emailTextField, psswrdTextField].forEach { section in
            section.setTextFieldDelegate(delegate: self)
        }
        mobileTextFiled.getTextField().addTarget(self, action: #selector(mobileNubmerLenghtLimiter(sender:)), for: .editingChanged)
    }
    
    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [userTextFiled, mobileTextFiled, emailTextField, psswrdTextField])
        setupTextFields()
        stackViewConstraints()
        
        stackView.axis = .vertical
        stackView.spacing = 28
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
    }
    
    private func stackViewConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(registerSubLabel.snp_bottomMargin).inset(-40)
            make.height.equalTo(250)
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
        psswrdTextField.addSubview(secureButton)
        secureButton.snp.makeConstraints { maker in
            maker.right.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(10)
            maker.top.equalToSuperview().inset(10)
            maker.width.equalTo(20)
        }
    }
    
    private func setupTermsButton() {
        termsButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        termsButton.configuration  = .borderless()
        let termsButtonText = "By signing up you agree with our Terms of Use"
        termsButton.configuration?.attributedTitle = AttributedString(termsButtonText, attributes: container)
        termsButton.configuration?.titleAlignment = .center
        termsButton.configuration?.baseForegroundColor = .AppColor.nextButtonBlue
        termsButton.addTarget(self, action: #selector(termsButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func termsButtonConstraints() {
        addSubview(termsButton)
        termsButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(stackView.snp_bottomMargin).inset(-20)
            make.height.equalTo(30)
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
            maker.top.equalTo(termsButton.snp_bottomMargin).inset(-44)
        }
    }
    
    private func setupLoginBtnSubtitle() {
        loginBtnSubtitleConstraints()
        
        loginBtnSubtitle.text = "Already a member?"
        loginBtnSubtitle.textAlignment = .left
        loginBtnSubtitle.font = UIFont.systemFont(ofSize: 16)
        loginBtnSubtitle.textColor = .AppColor.subtitles
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
        
        loginButton.configuration = .borderless()
        loginButton.configuration?.attributedTitle = AttributedString("Sign in", attributes: container)
        loginButton.configuration?.baseForegroundColor = .AppColor.nextButtonBlue
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
extension RegistrationView {
    
    @objc private func nextButtonAction(sender: UIButton) {
        delegate?.nextButtonDidTapped(username: userTextFiled.getTextFieldText(),
                                      mobileNumber: mobileNumberOutputFormat(mobileTextFiled.getTextFieldText()) ,
                                      email: emailTextField.getTextFieldText(),
                                      password: psswrdTextField.getTextFieldText()
        )
    }
    
    @objc private func loginButtonAction(sender: UIButton) {
        delegate?.loginButtonDidTapped()
    }
    
    @objc private func termsButtonAction(sender: UIButton) {
        delegate?.termsButtonDidTapped()
    }
    
    @objc private func secureButtonAction(sender: UIButton) {
        psswrdTextField.toggleSecureTextField()
        
        switch psswrdTextField.isSecureTextFiled() {
        case true:
            secureButton.setBackgroundImage(UIImage(named: "Show"), for: .normal)
        case false:
            secureButton.setBackgroundImage(UIImage(named: "NotShow"), for: .normal)
        }
    }
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    @objc private func rightSwipeAction() {
        delegate?.didRightSwipeAction()
    }
    
    @objc private func mobileNubmerLenghtLimiter(sender: UITextField) {
        guard sender == mobileTextFiled.getTextField() else { return }
        if let text = sender.text, text.count == 10 {
            emailTextField.getTextField().becomeFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userTextFiled.getTextField():
            mobileTextFiled.getTextField().becomeFirstResponder()
        case mobileTextFiled.getTextField():
            emailTextField.getTextField().becomeFirstResponder()
        case emailTextField.getTextField():
            psswrdTextField.getTextField().becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == mobileTextFiled.getTextField() else { return true }
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = mobileNumberFormatter(mask: "+X (XXX) XXX-XX-XX", mobileNumber: newString)
        return false
    }
}
    
