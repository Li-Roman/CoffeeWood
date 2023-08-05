//
//  AuthSectionViewType.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 02.08.2023.
//

import Foundation
import UIKit

enum AuthSectionViewType {
    case username
    case mobileNumber
    case email
    case password
    
    func getTextFieldText() -> String {
        switch self {
        case .email:
            return UserDefaultsManager.shared.string(forKey: .emailTextFieldText) ?? ""
        default:
            return ""
        }
    }
    
    func getPlaceholderText() -> String {
        switch self {
        case .username:
            return "Username"
        case .mobileNumber:
            return "Mobile Number"
        case .email:
            return "Email Address"
        case .password:
            return "Password"
        }
    }
    
    func getKeyboardType() -> UIKeyboardType {
        switch self {
        case .mobileNumber:
            return .numberPad
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }
    
    func isSecureTextEntry() -> Bool {
        switch self {
        case .password:
            return true
        default:
            return false
        }
    }
    
    func getSectionImage() -> UIImage {
        switch self {
        case .username:
            return UIImage(named: "Person")!
        case .mobileNumber:
            return UIImage(named: "Phone")!
        case .email:
            return UIImage(named: "Message")!
        case .password:
            return UIImage(named: "Lock")!
        }
    }
}
