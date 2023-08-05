//
//  UserInfoSectionView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 29.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol UserProfileSectionViewDelegate: AnyObject {
    func textViewDidEndEditing(_ textView: UITextView)
    func textViewDidBeginEditing(_ textView: UITextView)
}

class UserProfileSectionView: UIView {
    
    weak var delegate: UserProfileSectionViewDelegate?
    
    private let sectionType: UserProfileSectionViewType
    private let user: DDUser
    
    private let iconView = UIView()
    private let iconImageView = UIImageView()
    private let sectionLabel = UILabel()
    private let textField = UITextField()
    private let textView = UITextView()
    private let editButton = UIButton()
    
    init(type: UserProfileSectionViewType, user: DDUser) {
        self.sectionType = type
        self.user = user
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func getTextViewText() -> String {
        guard let text = textView.text else { return "" }
        return text
    }
    
    private func changeUserInfo() -> DDUser {
        var currentUser = user
        switch sectionType {
        case .fullName:
            currentUser.name = getTextViewText()
        case .phoneNumber:
            currentUser.mobileNumber = getTextViewText()
        case .email:
            currentUser.email = getTextViewText()
        case .address:
            currentUser.address = getTextViewText()
        }
        return currentUser
    }
}

// MARK: - Internal Methods
extension UserProfileSectionView {
    func getTextView() -> UITextView {
        return textView
    }
    
    func getTextViewTextt() -> String {
        guard let text = textView.text else { return "" }
        return text
    }
    
    func offEditState() {
        textView.isEditable = false
        textView.resignFirstResponder()
        editButton.setImage(UIImage(named: "Edit"), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        delegate?.textViewDidEndEditing(textView)
    }
    
    func onEditState() {
        textView.isEditable = true
        textView.becomeFirstResponder()
        editButton.setImage(UIImage(named: "End.Edit"), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
    }
}

// MARK: - Setup View
extension UserProfileSectionView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupIconView()
        setupIconImageView()
        setupSectionLabel()
        setupTextView()
        setupEditButton()
    }
    
    private func setupIconView() {
        iconViewConstraints()
        
        iconView.backgroundColor = AppColors.Background.grayBack
        iconView.layer.cornerRadius = 22
        iconView.clipsToBounds = true
    }
    
    private func iconViewConstraints() {
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.width.equalTo(44)
        }
    }
    
    private func setupIconImageView() {
        iconImageViewConstraints()
        
        iconImageView.image = sectionType.getIconImage()
        iconImageView.clipsToBounds = true
    }
    
    private func iconImageViewConstraints() {
        iconView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    private func setupSectionLabel() {
        sectionLabelConstraints()
        
        sectionLabel.text = sectionType.getLabelText()
        sectionLabel.textAlignment = .left
        sectionLabel.font = UIFont(name: "Poppins-Regular", size: 11)
        sectionLabel.textColor = AppColors.Labels.gray
    }
    
    private func sectionLabelConstraints() {
        addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp_rightMargin).inset(-24)
            make.top.equalToSuperview().inset(6)
            make.height.equalTo(12)
            make.width.equalTo(100)
        }
    }
    
    private func setupTextView() {
        textViewConstraints()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Poppins-Medium", size: 15)!,
            .foregroundColor: AppColors.TextField.Text.blue,
        ]
        let textViewText = sectionType.getTextFieldText(user: user)
        textView.attributedText = NSAttributedString(string: textViewText, attributes: attributes)
        textView.font = UIFont(name: "Poppins-Medium", size: 15)!
        textView.textColor = AppColors.TextField.Text.blue
        textView.keyboardType = sectionType.getKeyboradType()
        textView.textAlignment = .left
        textView.autocorrectionType = .no
        textView.isEditable = false
    }
    
    private func textViewConstraints() {
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp_rightMargin).inset(-20)
            make.right.equalToSuperview().inset(44)
            make.top.equalTo(sectionLabel.snp_bottomMargin).inset(-6)
            make.bottom.equalToSuperview()
            
        }
    }
    
    private func setupEditButton() {
        editButtonConstraints()
            
        editButton.setImage(UIImage(named: "Edit"), for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.addTarget(self, action: #selector(editButtonAction(sender:)), for: .touchUpInside)
    }
    
    private func editButtonConstraints() {
        addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(1)
            make.top.equalToSuperview().inset(9)
            make.height.width.equalTo(24)
        }
    }
}

// MARK: - Actions
extension UserProfileSectionView {
    @objc func editButtonAction(sender: UIButton) {

        switch textView.isEditable {
        case true:
            textView.isEditable = false
            editButton.setImage(UIImage(named: "Edit"), for: .normal)
            editButton.imageView?.contentMode = .scaleAspectFit
            textView.resignFirstResponder()
            delegate?.textViewDidEndEditing(textView)
        case false:
            delegate?.textViewDidBeginEditing(textView)
        }
    }
}

// MARK: - UITextViewDelegate
extension UserProfileSectionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            textField.resignFirstResponder()
        }
        return true
    }
}
