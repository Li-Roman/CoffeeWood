//
//  SubLabel.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation
import UIKit

class SubLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

//MARK: - Setup View
extension SubLabel {
    private func setupView() {
        let attributedString = NSMutableAttributedString(string: "The best grain, the finest roast, the most powerful flavor.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedText = attributedString
        textAlignment = .center
        numberOfLines = 2
        font = UIFont(name: "Helvetica Neue", size: 16)
        textColor = .AppColor.subtitles
    }
}
