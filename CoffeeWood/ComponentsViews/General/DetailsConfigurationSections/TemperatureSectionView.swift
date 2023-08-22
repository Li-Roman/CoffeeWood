//
//  TemperatureSectionView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 14.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol TemperatureSectionViewDelegate: AnyObject {
    func updateTemperatureType(for type: TemperatureType)
}
 
class TemperatureSectionView: UIView {
    
    weak var delegate: TemperatureSectionViewDelegate?
    
    private var temperatureType = TemperatureType.hot
    
    private let temperatureLabel = UILabel()
    private let hotTypeButton = UIButton()
    private let iceTypeButton = UIButton()
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
extension TemperatureSectionView {
    private func setupView() {
        setupTemperatureLabel()
        setupIceTypeButton()
        setupHotTypeButton()
        setupBottomLine()
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.text = Resources.Strings.Details.temperatureLabel
        temperatureLabel.font = Resources.Font.Details.temperatureLabel
        temperatureLabel.textColor = AppColors.Labels.darkBlue
        temperatureLabel.textAlignment = .left
        
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    private func setupIceTypeButton() {
        iceTypeButton.setImage(Resources.Images.Details.iceButtonInactive, for: .normal)
        iceTypeButton.imageView?.contentMode = .scaleAspectFit
        iceTypeButton.addTarget(self, action: #selector(iceTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(iceTypeButton)
        iceTypeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(38)
            make.width.equalTo(35)
        }
    }
    
    private func setupHotTypeButton() {
        hotTypeButton.setImage(Resources.Images.Details.hotButtonActive, for: .normal)
        hotTypeButton.imageView?.contentMode = .scaleAspectFit
        hotTypeButton.addTarget(self, action: #selector(hotTypeButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(hotTypeButton)
        hotTypeButton.snp.makeConstraints { make in
            make.right.equalTo(iceTypeButton.snp_leftMargin).inset(-30)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(32)
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
extension TemperatureSectionView {
    @objc private func hotTypeButtonAction(sender: UIButton) {
        temperatureType = .hot
        iceTypeButton.setImage(Resources.Images.Details.iceButtonInactive, for: .normal)
        hotTypeButton.setImage(Resources.Images.Details.hotButtonActive, for: .normal)
        delegate?.updateTemperatureType(for: temperatureType)
    }
    
    @objc private func iceTypeButtonAction(sender: UIButton) {
        temperatureType = .iced
        iceTypeButton.setImage(Resources.Images.Details.iceButtonActive, for: .normal)
        hotTypeButton.setImage(Resources.Images.Details.hotButtonInactive, for: .normal)
        delegate?.updateTemperatureType(for: temperatureType)
    }
}
