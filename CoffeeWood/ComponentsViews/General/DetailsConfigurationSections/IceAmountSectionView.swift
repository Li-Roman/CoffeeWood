//
//  IceAmountSectionView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 14.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol IceAmountSectionViewDelegate: AnyObject {
    func updateIceAmountType(for type: IceAmount)
}

class IceAmountSectionView: UIView {
    
    weak var delegate: IceAmountSectionViewDelegate?
    
    private var iceAmountType = IceAmount.half
    
    private let iceAmountLabel = UILabel()
    private let littleTypeButton = UIButton()
    private let halfTypeButton = UIButton()
    private let fullTypeButton = UIButton()
    private let bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Setup View
extension IceAmountSectionView {
    private func setupView() {
        setupIceAmountLabel()
        setupButtons()
    }
    
    private func setupIceAmountLabel() {
        iceAmountLabel.text = Resources.Strings.Details.iceSectionLabel
        iceAmountLabel.font = Resources.Font.Details.iceSectionLabel
        iceAmountLabel.textColor = AppColors.Labels.darkBlue
        iceAmountLabel.textAlignment = .left
        
        addSubview(iceAmountLabel)
        iceAmountLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    private func setupButtons() {
        [littleTypeButton ,halfTypeButton, fullTypeButton].forEach { button in
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        setupFullTypeButton()
        setupHalfTypeButton()
        setupLittleTypeButton()
    }
    
    private func setupFullTypeButton() {
        fullTypeButton.setImage(Resources.Images.Details.fullIced, for: .normal)
        fullTypeButton.addTarget(self, action: #selector(fullTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(fullTypeButton)
        fullTypeButton.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
    
    private func setupHalfTypeButton() {
        halfTypeButton.setImage(Resources.Images.Details.halfIcedActive, for: .normal)
        halfTypeButton.addTarget(self, action: #selector(halfTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(halfTypeButton)
        halfTypeButton.snp.makeConstraints { make in
            make.right.equalTo(fullTypeButton.snp_leftMargin).inset(-36)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    
    private func setupLittleTypeButton() {
        littleTypeButton.setImage(Resources.Images.Details.littleIced, for: .normal)
        littleTypeButton.addTarget(self, action: #selector(littleTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(littleTypeButton)
        littleTypeButton.snp.makeConstraints { make in
            make.right.equalTo(halfTypeButton.snp_leftMargin).inset(-40)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
}

// MARK: - Actions
extension IceAmountSectionView {
    @objc private func littleTypeButtonAction(sender: UIButton) {
        iceAmountType = .little
        littleTypeButton.setImage(Resources.Images.Details.littleIcedActive, for: .normal)
        halfTypeButton.setImage(Resources.Images.Details.halfIced, for: .normal)
        fullTypeButton.setImage(Resources.Images.Details.fullIced, for: .normal)
        delegate?.updateIceAmountType(for: iceAmountType)
    }
    
    @objc private func halfTypeButtonAction(sender: UIButton) {
        iceAmountType = .half
        littleTypeButton.setImage(Resources.Images.Details.littleIced, for: .normal)
        halfTypeButton.setImage(Resources.Images.Details.halfIcedActive, for: .normal)
        fullTypeButton.setImage(Resources.Images.Details.fullIced, for: .normal)
        delegate?.updateIceAmountType(for: iceAmountType)
    }
    
    @objc private func fullTypeButtonAction(sender: UIButton) {
        iceAmountType = .full
        littleTypeButton.setImage(Resources.Images.Details.littleIced, for: .normal)
        halfTypeButton.setImage(Resources.Images.Details.halfIced, for: .normal)
        fullTypeButton.setImage(Resources.Images.Details.fullIcedActive, for: .normal)
        delegate?.updateIceAmountType(for: iceAmountType)
    }
}
