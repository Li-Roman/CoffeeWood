//
//  CartPositionCount.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

class CartPositionsCountView: UIView {
    
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func updateCountNumber(for count: Int) {
        self.countLabel.text = "\(count)"
    }
    
    // MARK: - Setup View
    private func setupView() {
        backgroundColor = .systemRed
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.font = UIFont(name: "Poppins-SemiBold", size: 10)
    }
}
