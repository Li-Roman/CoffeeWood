//
//  VerificationView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 26.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol VerificationViewDelegate: AnyObject {
    func didRightSwipeAction()
    func didTappedNextButton(smsCode: String?)
}

class VerificationView: UIView {
    
    weak var delegate: VerificationViewDelegate?
    
    private let verificationLabel = UILabel()
    private let verificationSubLabel = UILabel()
    private let nextButton = CircleNextButton()
    private let sendCodeButton = UIButton()
    private var sectionsKeyStackView = UIStackView()
    private let firstSection = VerificationSectionView()
    private let secondSection = VerificationSectionView()
    private let thirdSection = VerificationSectionView()
    private let fourthSection = VerificationSectionView()
    private let fifthSection = VerificationSectionView()
    private let sixthSection = VerificationSectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    deinit {
        print("VerificationView is dead")
    }
}

// MARK: - Internal Methods
extension VerificationView {
    func clearAllTextFields() {
        [firstSection, secondSection, thirdSection, fourthSection, fifthSection, sixthSection].forEach { section in
            section.clearTextFiled()
        }
    }
}

//MARK: - Private Methods
extension VerificationView {
    private func makeSections() -> [VerificationSectionView] {
        let array = Array(repeating: VerificationSectionView(), count: 6)
        print(" array count = \(array.count)")
        return array
    }
    
    private func getCode() -> String? {
        var code = ""
        [firstSection, secondSection, thirdSection, fourthSection, fifthSection, sixthSection].forEach { section in
            code += section.getSectionText()
        }
        return code
    }
}

//MARK: - Setup View
extension VerificationView {
    private func setupView() {
        backgroundColor = .systemBackground
        setupVerificationLabel()
        setupVerificationSubLabel()
        setupSectionsKeyStackView()
        setupSendCodeButton()
        setupNextButton()
        setupGestureRecognizers()
    }
    
    private func setupVerificationLabel() {
        verificationLabelConstraints()
        
        verificationLabel.text = "Verification"
        verificationLabel.font = UIFont(name: "Poppins-Medium", size: 24)
        verificationLabel.textColor = .AppColor.mainLabels
        verificationLabel.textAlignment = .left
    }
    
    private func verificationLabelConstraints() {
        addSubview(verificationLabel)
        verificationLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(40)
            maker.top.equalToSuperview().inset(130)
            maker.height.equalTo(40)
        }
    }
    
    private func setupVerificationSubLabel() {
        verificationSubLabelConstraints()
        
        verificationSubLabel.text = "Enter the OTP code we sent you"
        verificationSubLabel.font = UIFont(name: "Poppins-Regular", size: 15)
        verificationSubLabel.textColor = .AppColor.subtitles
        verificationSubLabel.textAlignment = .left
    }
    
    private func verificationSubLabelConstraints() {
        addSubview(verificationSubLabel)
        verificationSubLabel.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview().inset(40)
            maker.top.equalTo(verificationLabel).inset(48)
            maker.height.equalTo(40)
        }
    }
    
    private func setupKeySections(_ sections: [VerificationSectionView]) {
        
        sections.forEach { section in
            section.setTextFieldDelegate(self)
            section.layer.cornerRadius = 10
            section.clipsToBounds = true
            section.textField.addTarget(self, action: #selector(changeTextField(sender:)), for: .editingChanged)
        }
    }
    
    private func setupSectionsKeyStackView() {
        let sections = [firstSection, secondSection, thirdSection, fourthSection, fifthSection, sixthSection]
        sectionsKeyStackView = UIStackView(arrangedSubviews: sections)
        setupKeySections(sections)
        sectionsKeyStackViewConstraints()
        
        sectionsKeyStackView.spacing = 14
        sectionsKeyStackView.alignment = .fill
        sectionsKeyStackView.distribution = .fillEqually
        sectionsKeyStackView.axis = .horizontal
    }
    
    private func sectionsKeyStackViewConstraints() {
        addSubview(sectionsKeyStackView)
        sectionsKeyStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(verificationSubLabel.snp_bottomMargin).inset(-50)
            make.height.equalTo(64)
        }
    }
    
    private func setupSendCodeButton() {
        sendCodeButtonConstraints()
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 14)
        sendCodeButton.configuration  = .borderless()
        let termsButtonText = "Send Code"
        sendCodeButton.configuration?.attributedTitle = AttributedString(termsButtonText, attributes: container)
        sendCodeButton.configuration?.titleAlignment = .center
        sendCodeButton.configuration?.baseForegroundColor = .AppColor.nextButtonBlue
        sendCodeButton.addTarget(self, action: #selector(sendCodeButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func sendCodeButtonConstraints() {
        addSubview(sendCodeButton)
        sendCodeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(sectionsKeyStackView.snp_bottomMargin).inset(-40)
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
            maker.top.equalTo(sendCodeButton.snp_bottomMargin).inset(-70)
        }
    }
    
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

// MARK: - Actions
extension VerificationView {
    @objc private func sendCodeButtonAction(sender: UIButton) {
        print("Send Code Button Action")
    }
    
    @objc private func nextButtonAction(sender: UIButton) {
        print("Next Button did tapped in RegistrationViewPresenter with smsCode = \(getCode() ?? "0")")
        delegate?.didTappedNextButton(smsCode: getCode())
    }
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    @objc func rightSwipeAction() {
        delegate?.didRightSwipeAction()
    }
    
    @objc private func changeTextField(sender: UITextField) {
        if let text = sender.text, text.count == 1 {
            switch sender {
            case firstSection.getTextField():
                secondSection.getTextField().becomeFirstResponder()
            case secondSection.getTextField():
                thirdSection.getTextField().becomeFirstResponder()
            case thirdSection.getTextField():
                fourthSection.getTextField().becomeFirstResponder()
            case fourthSection.getTextField():
                fifthSection.getTextField().becomeFirstResponder()
            case fifthSection.getTextField():
                sixthSection.getTextField().becomeFirstResponder()
            case sixthSection.getTextField():
                sender.resignFirstResponder()
            default: break
            }
        } else if sender.text!.isEmpty {
            switch sender {
            case sixthSection.getTextField():
                fifthSection.getTextField().becomeFirstResponder()
            case fifthSection.getTextField():
                fourthSection.getTextField().becomeFirstResponder()
            case fourthSection.getTextField():
                thirdSection.getTextField().becomeFirstResponder()
            case thirdSection.getTextField():
                secondSection.getTextField().becomeFirstResponder()
            case secondSection.getTextField():
                firstSection.getTextField().becomeFirstResponder()
            default: break
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension VerificationView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count == 1 && !string.isEmpty {
            return false
        } else {
            return true
        }
    }
}
