import Foundation
import UIKit

enum UserProfileSectionViewType {
    case fullName
    case phoneNumber
    case email
    case address
    
    func getLabelText() -> String {
        switch self {
        case .fullName:
            return "Full name"
        case .phoneNumber:
            return "Phone number"
        case .email:
            return "Email"
        case .address:
            return "Address"
        }
    }
    
    func getIconImage() -> UIImage {
        switch self {
        case .fullName:
            return UIImage(named: "Person.fill")!
        case .phoneNumber:
            return UIImage(named: "PhoneHandset.fill")!
        case .email:
            return UIImage(named: "Message.fill")!
        case .address:
            return UIImage(named: "Address.fill")!
        }
    }
    
    func getKeyboradType() -> UIKeyboardType {
        switch self {
        case .phoneNumber:
            return .numberPad
        case .email:
            return .emailAddress
        default:
            return .default
        }
    }
    
    func getPlaceholderText() -> String {
        switch self {
        case .fullName:
            return "Enter your name"
        case .phoneNumber:
            return "Enter your phone number"
        case .email:
            return "Enter your email"
        case .address:
            return "Enter your address"
        }
    }
    
    func getTextFieldText(user: DDUser?) -> String {
        switch self {
        case .fullName:
            return user?.name ?? "fullName"
        case .phoneNumber:
            return user?.mobileNumber ?? "phoneNumber"
        case .email:
            return user?.email ?? "email"
        case .address:
            return user?.address ?? "address"
        }
    }
}
