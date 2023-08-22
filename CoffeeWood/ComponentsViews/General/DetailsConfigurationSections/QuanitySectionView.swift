//
//  QuanitySelectionSection.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 13.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol QuanitySectionViewDelegate: AnyObject {
    func updateQuanity(count: Int)
}

class QuanitySectionView: UIView {
    
    weak var delegate: QuanitySectionViewDelegate?
    
    private let labelText: String
    
    private let label = UILabel()
    private let counter = CustomStepper()
    private let bottomLine = UIView()
    
    init(productName: String) {
        labelText = productName
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Setup View
extension QuanitySectionView {
    private func setupView() {
        setupLabel()
        setupCounter()
        setupBottomLine()
    }
    
    private func setupLabel() {
        label.text = labelText.capitalized
        label.font = Resources.Font.Details.quanitySectionLabel
        label.textColor = AppColors.Labels.darkBlue
        label.textAlignment = .left
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(22)
        }
    }
    
    private func setupCounter() {
        counter.delegate = self
        counter.layer.cornerRadius = 15
        counter.layer.borderWidth = 1
        counter.layer.borderColor = AppColors.Lines.gray.cgColor
        
        addSubview(counter)
        counter.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(74)
            make.height.equalTo(30)
        }
    }
    
    private func setupBottomLine() {
        bottomLine.backgroundColor = AppColors.Lines.lightGray
        
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.bottom.right.left.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension QuanitySectionView: CustomStepperDelegate {
    func updateCount(count: Int) {
        delegate?.updateQuanity(count: count)
    }
}
