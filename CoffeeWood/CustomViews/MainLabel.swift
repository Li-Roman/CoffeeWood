//
//  MainLabel.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 25.07.2023.
//

import Foundation
import UIKit

class MainLabel: UILabel {

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
extension MainLabel {
    private func setupView() {
        let attributedString = NSMutableAttributedString(string: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedText = attributedString
        textAlignment = .center
        numberOfLines = 2
        font = .boldSystemFont(ofSize: 26)
        textColor = .AppColor.mainLabels
    }
}
