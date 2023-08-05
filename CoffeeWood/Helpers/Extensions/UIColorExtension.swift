//
//  UIColorExtension.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import UIKit

//extension UIColor {
//    struct AppColor {
//        static var nextButtonBlue : UIColor { return UIColor(red: 50/255, green: 74/255, blue: 89/255, alpha: 1) }
//        static var mainLabels : UIColor { return UIColor(red: 24/255, green: 29/255, blue: 45/255, alpha: 1) }
//        static var subtitles : UIColor { return UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1) }
//        static var placeholders: UIColor { return UIColor(red: 193/255, green: 198/255, blue: 208/255, alpha: 1) }
//        static var lines: UIColor { return UIColor(red: 193/255, green: 198/255, blue: 208/255, alpha: 1) }
//        static var textButtons: UIColor { return UIColor(red: 50/255, green: 73/255, blue: 88/255, alpha: 1) }
//        static var verificationSectionBackground: UIColor { return UIColor(red: 247/255, green: 248/255, blue: 251/255, alpha: 1) }
//    }
//}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

enum AppColors {
    enum Background {
        static let whiteBack = UIColor(hexString: "#FFFFFF")
        static let blueBack = UIColor(hexString: "#324A59")
        static let grayBack = UIColor(hexString: "#F7F8FB")
        static let brown = UIColor(hexString: "#E4D5C9")
    }
    
    enum Buttons {
        enum Back {
            static let blue = UIColor(hexString: "#324A59")
            static let pink = UIColor(hexString: "#FFE5E5")
            static let red = UIColor(hexString: "#FF3030")
            static let darkBlue = UIColor(hexString: "#001833")
        }
        
        enum Icon {
            static let whiteIcon = UIColor(hexString: "#FFFFFF")
            static let redIcon = UIColor(hexString: "#FF3030")
        }
        
        enum TextButton {
            static let blue = UIColor(hexString: "#324A59")
            static let darkBlue = UIColor(hexString: "#001833")
        }
    }
    
    enum NavController {
        static let darkBlue = UIColor(hexString: "#001833")
    }
    
    enum Labels {
        static let blue = UIColor(hexString: "#324A59")
        static let darkBlue = UIColor(hexString: "#181D2D")
        static let gray = UIColor(hexString: "#98A4AC")
        static let lightGray = UIColor(hexString: "#AAAAAA")
    }
    
    enum TextField {
        enum Text {
            static let blue = UIColor(hexString: "#324A59")
        }
        
        enum Placeholder {
            static let gray = UIColor(hexString: "#C1C7D0")
        }
    }
    
    enum PageControl {
        static let blue = UIColor(hexString: "#324A59")
        static let gray = UIColor(hexString: "#98A4AC")
    }
    
    enum Lines {
        static let gray = UIColor(hexString: "#C1C7D0")
    }
}
