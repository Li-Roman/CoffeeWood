//
//  SizeSectionView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 14.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol CupSizeSectioniewDelegate: AnyObject {
    func updateCupSizeType(for type: CupSize)
}

class CupSizeSectioniew: UIView {
    
    weak var delegate: CupSizeSectioniewDelegate?
    
    private var cupSizeType = CupSize.medium
    
    private let cupSizeLabel = UILabel()
    private let smallTypeButton = UIButton()
    private let mediumTypeButton = UIButton()
    private let largeTypeButton = UIButton()
    private let bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func getTemperatureType() -> CupSize {
        return cupSizeType
    }
    
    // MARK: - Private Methods
    private func setInactiveImage(for buttons: [UIButton]) {
        buttons.forEach { button in
            button.setImage(Resources.Images.Details.sizeTypeButton, for: .normal)
        }
    }
}

// MARK: - Setup View
extension CupSizeSectioniew {
    private func setupView() {
        setupCupSizeLabel()
        setupButtons()
        setupBottomLine()
    }
    
    private func setupCupSizeLabel() {
        cupSizeLabel.text = Resources.Strings.Details.sizeSectionLabel
        cupSizeLabel.font = Resources.Font.Details.cupSizeLabel
        cupSizeLabel.textColor = AppColors.Labels.darkBlue
        cupSizeLabel.textAlignment = .left
        
        addSubview(cupSizeLabel)
        cupSizeLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    private func setupButtons() {
        [smallTypeButton, mediumTypeButton, largeTypeButton].forEach { button in
            button.setImage(Resources.Images.Details.sizeTypeButton, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        setupLargeTypeButton()
        setupMediumTypeButton()
        setupSmallTypeButton()
    }
    
    private func setupLargeTypeButton() {
        largeTypeButton.addTarget(self, action: #selector(largeTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(largeTypeButton)
        largeTypeButton.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(30)
        }
    }
    
    private func setupMediumTypeButton() {
        mediumTypeButton.addTarget(self, action: #selector(mediumTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(mediumTypeButton)
        mediumTypeButton.snp.makeConstraints { make in
            make.right.equalTo(largeTypeButton.snp_leftMargin).inset(-40)
            make.bottom.equalTo(largeTypeButton)
            make.height.equalTo(32)
            make.width.equalTo(25)
        }
    }
    
    private func setupSmallTypeButton() {
        smallTypeButton.setImage(Resources.Images.Details.sizeTypeButtonActive, for: .normal)
        smallTypeButton.addTarget(self, action: #selector(smallTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(smallTypeButton)
        smallTypeButton.snp.makeConstraints { make in
            make.right.equalTo(mediumTypeButton.snp_leftMargin).inset(-40)
            make.bottom.equalTo(mediumTypeButton)
            make.height.equalTo(23)
            make.width.equalTo(18)
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

// MARK: - Actions
extension CupSizeSectioniew {
    @objc private func smallTypeButtonAction(sender: UIButton) {
        cupSizeType = .small
        setInactiveImage(for: [mediumTypeButton, largeTypeButton])
        sender.setImage(Resources.Images.Details.sizeTypeButtonActive, for: .normal)
        delegate?.updateCupSizeType(for: cupSizeType)
    }
    
    @objc private func mediumTypeButtonAction(sender: UIButton) {
        cupSizeType = .medium
        setInactiveImage(for: [smallTypeButton, largeTypeButton])
        sender.setImage(Resources.Images.Details.sizeTypeButtonActive, for: .normal)
        delegate?.updateCupSizeType(for: cupSizeType)
    }
    
    @objc private func largeTypeButtonAction(sender: UIButton) {
        cupSizeType = .large
        setInactiveImage(for: [smallTypeButton, mediumTypeButton])
        sender.setImage(Resources.Images.Details.sizeTypeButtonActive, for: .normal)
        delegate?.updateCupSizeType(for: cupSizeType)
    }
}
