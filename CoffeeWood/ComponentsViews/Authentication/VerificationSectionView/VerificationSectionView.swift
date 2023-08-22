//
//  VerificationSectionView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 26.07.2023.
//

import Foundation
import UIKit
import SnapKit

class VerificationSectionView: UIView {
    
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

//MARK: - Internal Methods
extension VerificationSectionView {
    func getSectionText() -> String {
        guard let text = textField.text else { return "" }
        return text
    }
    
    func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    func clearTextFiled() {
        textField.text = ""
    }
}

//MARK: - Setup View
extension VerificationSectionView {
    private func setupView() {
        setupTextFiled()
        backgroundColor = AppColors.Background.grayBack
    }
    
    private func setupTextFiled() {
        textFieldConstraints()
        
        textField.placeholder = ""
        textField.font = UIFont(name: "Poppins-Medium", size: 24)
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.textColor = .gray
        textField.autocorrectionType = .no
        textField.clearButtonMode = .never
    }
    
    private func textFieldConstraints() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}
