//
//  NextButton.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 19.07.2023.
//

import Foundation
import UIKit

class NextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButtonImage(size: CGFloat = 20) {
        let config = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: "arrow.right")!.withConfiguration(config)
        
        configuration?.image = image.withTintColor(.white)
//        configuration?.imagePlacement = .all
    }
    
    private func setupButton() {
        
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.baseBackgroundColor = UIColor(red: 50/255, green: 75/255, blue: 89/255, alpha: 1)
        setupButtonImage()
    }
    
}
