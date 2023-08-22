//
//  ShotSection.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 13.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol ShotSectionViewDelegate: AnyObject {
    func updateShotType(for type: EspressoShot)
}

class ShotSectionView: UIView {
    
    weak var delegate: ShotSectionViewDelegate?
    
    private var shotType = EspressoShot.single
    
    private let shotLabel = UILabel()
    private let singleButton = UIButton()
    private let doubleButton = UIButton()
    private let bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ShotSectionView {
    private func setupView() {
        setupShotLabel()
        setupButtons()
        setupBottomLine()
    }
    
    private func setupShotLabel() {
        shotLabel.text = Resources.Strings.Details.shotSectionLabel
        shotLabel.font = Resources.Font.Details.shotSectionLabel
        shotLabel.textColor = AppColors.Labels.darkBlue
        shotLabel.textAlignment = .left
        
        addSubview(shotLabel)
        shotLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    private func setupButtons() {
        [singleButton, doubleButton].forEach { button in
            button.titleLabel?.font = Resources.Font.Details.shotButton
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(AppColors.Buttons.TextButton.darkBlue, for: .normal)
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
        }
        setupDoubleButton()
        setupSingleButton()
    }
    
    private func setupDoubleButton() {
        doubleButton.setTitle(Resources.Strings.Details.doubleButton, for: .normal)
        doubleButton.layer.borderColor = AppColors.Lines.gray.cgColor
        doubleButton.addTarget(self, action: #selector(doubleButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(doubleButton)
        doubleButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(74)
            make.height.equalTo(30)
        }
    }
    
    private func setupSingleButton() {
        singleButton.setTitle(Resources.Strings.Details.singleButton, for: .normal)
        singleButton.layer.borderColor = AppColors.Buttons.Back.darkBlue.cgColor
        singleButton.addTarget(self, action: #selector(singleButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(singleButton)
        singleButton.snp.makeConstraints { make in
            make.right.equalTo(doubleButton.snp_leftMargin).inset(-16)
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

extension ShotSectionView {
    @objc private func singleButtonAction(sender: UIButton) {
        singleButton.layer.borderColor = AppColors.Buttons.Back.darkBlue.cgColor
        doubleButton.layer.borderColor = AppColors.Lines.gray.cgColor
        shotType = .single
        delegate?.updateShotType(for: shotType)
    }
    
    @objc private func doubleButtonAction(sender: UIButton) {
        doubleButton.layer.borderColor = AppColors.Buttons.Back.darkBlue.cgColor
        singleButton.layer.borderColor = AppColors.Lines.gray.cgColor
        shotType = .double
        delegate?.updateShotType(for: shotType)
    }
}
