//
//  AuthViewWithTextField.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation
import UIKit
import SnapKit

class AuthViewWithTextField: UIView {
    
    private let sectionType: AuthSectionViewType
    
    private let horizonalLine = UIView()
    private let verticalLine = UIView()
    private let imageView = UIImageView()
    private let textField = UITextField()
    private let showPasswordButton = UIButton()
    
    init(_ sectionType: AuthSectionViewType, _ returnKeyType: UIReturnKeyType) {
        self.sectionType = sectionType
        textField.returnKeyType = returnKeyType
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods
    func getTextFieldText() -> String? {
        textField.text
    }
    
    func setTextFieldDelegate(delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    func toggleSecureTextField() {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }
    
    func isSecureTextFiled() -> Bool {
        return textField.isSecureTextEntry
    }
    
    func clearTextFiledText() {
        textField.text = ""
    }
}

// MARK: - Setup View
extension AuthViewWithTextField {
    func setupView() {
        [horizonalLine, verticalLine, imageView, textField].forEach {
            addSubview($0)
        }
        
        setupHorizontalLine()
        setupVerticalLine()
        setupImageView()
        setupTextFiled()
    }
    
    private func setupHorizontalLine() {
        horizonalLine.backgroundColor = AppColors.Lines.gray
        
        horizonalLine.snp.makeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(1)
        }
    }
    
    private func setupVerticalLine() {
        verticalLine.backgroundColor = AppColors.Lines.gray
        
        verticalLine.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(40)
            maker.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-5)
            maker.width.equalTo(1)
        }
    }
    
    private func setupImageView() {
        imageView.image = sectionType.getSectionImage()
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(11)
            maker.right.equalTo(verticalLine).offset(-11)
            maker.top.equalToSuperview().offset(11)
            maker.bottom.equalToSuperview().offset(-11)
        }
    }
    
    private func setupTextFiled() {
        textField.text = sectionType.getTextFieldText()
        textField.placeholder = sectionType.getPlaceholderText()
        textField.keyboardType = sectionType.getKeyboardType()
        textField.isSecureTextEntry = sectionType.isSecureTextEntry()
        textField.borderStyle = .none
        textField.font = UIFont(name: "Poppins-Medium", size: 15)!
        textField.textColor = AppColors.TextField.Text.blue
        textField.adjustsFontSizeToFitWidth = true
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        
        textField.snp.makeConstraints { maker in
            maker.left.equalTo(verticalLine).offset(20)
            maker.top.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(-4)
            maker.right.equalToSuperview().offset(-40)
        }
    }
}

