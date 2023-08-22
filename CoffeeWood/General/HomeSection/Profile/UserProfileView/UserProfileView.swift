//
//  UserProfileView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 29.07.2023.
//

import Foundation
import UIKit
import SnapKit

protocol UserProfileViewDelegate: AnyObject {
    func didChangeUserInfo(user: DDUser)
    func didLogoutButtonTapped()
}

class UserProfileView: UIView {
    
    weak var delegate: UserProfileViewDelegate?
    
    private var sectionStackView = UIStackView()
    private let fullNameSectionView: UserProfileSectionView
    private let phoneNumberSectionView: UserProfileSectionView
    private let emailSectionView: UserProfileSectionView
    private let addressSectionView: UserProfileSectionView
    
    private var user: DDUser
    
    init(user: DDUser) {
        self.user = user
        fullNameSectionView = UserProfileSectionView(type: .fullName, user: user)
        phoneNumberSectionView = UserProfileSectionView(type: .phoneNumber, user: user)
        emailSectionView = UserProfileSectionView(type: .email, user: user)
        addressSectionView = UserProfileSectionView(type: .address, user: user)
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("UserProfileView is dead")
    }
    
    private func offTextViewEdit(except: UserProfileSectionView) {
        [fullNameSectionView, phoneNumberSectionView, emailSectionView, addressSectionView].filter { section in
            section != except
        }.forEach { section in
            section.offEditState()
        }
        except.onEditState()
    }
}

// MARK: - Setup View
extension UserProfileView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        [fullNameSectionView, phoneNumberSectionView, emailSectionView, addressSectionView].forEach { section in
            section.delegate = self
        }
        setupSectionStackView()
    }
    
    private func setupSectionStackView() {
        sectionStackView = UIStackView(arrangedSubviews: [fullNameSectionView,
                                                          phoneNumberSectionView,
                                                          emailSectionView,
                                                          addressSectionView])
        sectionStackViewConstraints()
        
        sectionStackView.axis = .vertical
        sectionStackView.spacing = 20
        sectionStackView.alignment = .fill
        sectionStackView.distribution = .fillProportionally
    }
    
    private func sectionStackViewConstraints() {
        addSubview(sectionStackView)
        sectionStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalToSuperview().inset(114)
            make.height.equalTo(400)
        }
    }
}

extension UserProfileView: UserProfileSectionViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case fullNameSectionView.getTextView():
            user.name = fullNameSectionView.getTextViewTextt()
        case phoneNumberSectionView.getTextView():
            user.mobileNumber = phoneNumberSectionView.getTextViewTextt()
        case emailSectionView.getTextView():
            user.email = emailSectionView.getTextViewTextt()
        case addressSectionView.getTextView():
            user.address = addressSectionView.getTextViewTextt()
        default: break
        }
        delegate?.didChangeUserInfo(user: user)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case fullNameSectionView.getTextView():
            offTextViewEdit(except: fullNameSectionView)
        case phoneNumberSectionView.getTextView():
            offTextViewEdit(except: phoneNumberSectionView)
        case emailSectionView.getTextView():
            offTextViewEdit(except: emailSectionView)
        case addressSectionView.getTextView():
            offTextViewEdit(except: addressSectionView)
        default: break
        }
    }
}
