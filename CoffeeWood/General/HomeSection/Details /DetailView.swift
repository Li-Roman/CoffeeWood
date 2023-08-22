//
//  DetailView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 13.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol DetailViewDelegate: AnyObject {
    func didQuanityChange(for count: Int)
    func didShotChange(for type: EspressoShot)
    func didTemperatureTypeChange(for type: TemperatureType)
    func didCupSizeChange(for type: CupSize)
    func didIceAmountChange(for type: IceAmount)
    func didTappedCheckoutButton()
    func didTappedCartButton()
    func didTappedBackArrowButton()
    func willShowCartCountLabel()
}

class DetailView: UIView {
    
    weak var delegate: DetailViewDelegate?
    
    private let coffeeProduct: CoffeeProduct
    
    private let detailsLabel = UILabel()
    private let cartButton = UIButton()
    private let cartPositionsCountView = CartPositionsCountView()
    private let backArrowButton = UIButton()
    private let coffeeProductView = UIView()
    private let coffeeProductImageView = UIImageView()
    private var configurationStackView = UIStackView()
    private var quanitySectionView: QuanitySectionView!
    private let shotSectionView = ShotSectionView()
    private let temperatureSectionView = TemperatureSectionView()
    private let cupSizeSectionView = CupSizeSectioniew()
    private let iceAmountSectionView = IceAmountSectionView()
    private let totalAmountLabel = UILabel()
    private let totalCostLabel = UILabel()
    private let checkoutButton = UIButton()
    
    init(coffeeProduct: CoffeeProduct) {
        self.coffeeProduct = coffeeProduct
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print("DetailView is dead")
    }
    
    // MARK: - Internal Methods
    func updateResulCostLabel(for price: Double) {
        DispatchQueue.main.async {
            self.totalCostLabel.text = "$\(price)0"
        }
    }
    
    func updateCartLabelCount(withAnimate: Bool, count: Int) {
        DispatchQueue.main.async {
            switch withAnimate {
                case true:
                self.updateWithAnimate(for: count)
                case false:
                self.cartPositionsCountView.isHidden = count > 0 ? false : true
                self.cartPositionsCountView.updateCountNumber(for: count)
            }
        }
    }
    
    private func updateWithAnimate(for count: Int) {
        if self.cartPositionsCountView.isHidden {
            UIView.animate(withDuration: 0.15) {
                self.cartPositionsCountView.isHidden = false
            } completion: { _ in
                self.animateCartCountView(for: count)
            }
        } else {
            animateCartCountView(for: count)
        }
    }
    
    private func animateCartCountView(for count: Int) {
        cartPositionsCountView.updateCountNumber(for: count)
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            self.cartPositionsCountView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
                self.cartPositionsCountView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
}

// MARK: - Setup View
extension DetailView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupBackArrowButton()
        setupDetailsLabel()
        setupCartButton()
        setupCartPositionsCountView()
        setupCoffeeProductView()
        setupCoffeeProductImageView()
        setupConfigurationStackView()
        setupCheckoutButton()
        setupTotalAmountLabel()
        setupTotalCostLabel()
    }
    
    private func setupBackArrowButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let arrowImage = Resources.Images.Details.backArrowButton.withConfiguration(config)
        
        backArrowButton.configuration = .borderless()
        backArrowButton.configuration?.image = arrowImage
        backArrowButton.configuration?.baseForegroundColor = AppColors.Buttons.Back.darkBlue
        backArrowButton.configuration?.imagePlacement = .all
        backArrowButton.addTarget(self, action: #selector(backArrowButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(backArrowButton)
        backArrowButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(64)
            make.left.equalToSuperview().inset(30)
            make.height.width.equalTo(22)
        }
    }
    
    private func setupDetailsLabel() {
        detailsLabel.text = Resources.Strings.Details.detailsLabel
        detailsLabel.font = Resources.Font.Details.detailsLabel
        detailsLabel.textColor = AppColors.Labels.darkBlue
        detailsLabel.textAlignment = .center
        
        addSubview(detailsLabel)
        detailsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(64)
            make.height.equalTo(25)
            make.width.equalTo(60)
        }
    }
    
    private func setupCartButton() {
        cartButton.setImage(Resources.Images.Details.cartButton, for: .normal)
        cartButton.backgroundColor = AppColors.Buttons.Back.white
        cartButton.imageView?.contentMode = .scaleAspectFit
        cartButton.addTarget(self, action: #selector(cartButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(cartButton)
        cartButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(66)
            make.right.equalToSuperview().inset(34)
            make.height.width.equalTo(22)
        }
    }
    
    private func setupCartPositionsCountView() {
        cartPositionsCountView.isHidden = true
        cartPositionsCountView.layer.cornerRadius = 9
        cartPositionsCountView.clipsToBounds = true
        
        delegate?.willShowCartCountLabel()
        
        addSubview(cartPositionsCountView)
        cartPositionsCountView.snp.makeConstraints { make in
            make.top.equalTo(cartButton).inset(-8)
            make.right.equalTo(cartButton).inset(-8)
            make.height.width.equalTo(18)
        }
    }
    
    private func setupCoffeeProductView() {
        coffeeProductView.backgroundColor = AppColors.Background.grayBack
        coffeeProductView.layer.cornerRadius = 12
        coffeeProductView.clipsToBounds = true
        
        addSubview(coffeeProductView)
        coffeeProductView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(110)
            make.height.equalTo(152)
        }
    }
    
    private func setupCoffeeProductImageView() {
        coffeeProductImageView.image = coffeeProduct.image
        coffeeProductImageView.contentMode = .scaleAspectFit
        
        coffeeProductView.addSubview(coffeeProductImageView)
        coffeeProductImageView.snp.makeConstraints { make in
            make.centerY.equalTo(coffeeProductView.snp_bottomMargin)
            make.right.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(36)
            make.height.equalTo(280)
        }
    }
    
    private func setupConfigurationStackView() {
        quanitySectionView = QuanitySectionView(productName: coffeeProduct.title)
        
        quanitySectionView!.delegate = self
        shotSectionView.delegate = self
        temperatureSectionView.delegate = self
        cupSizeSectionView.delegate = self
        
        let subViews = [quanitySectionView!, shotSectionView, temperatureSectionView, cupSizeSectionView, iceAmountSectionView]
        configurationStackView = UIStackView(arrangedSubviews: subViews)
        configurationStackView.axis = .vertical
        configurationStackView.spacing = 0
        configurationStackView.alignment = .fill
        configurationStackView.distribution = .fillEqually
        
        addSubview(configurationStackView)
        configurationStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(coffeeProductView.snp_bottomMargin).inset(-26)
            make.height.equalTo((subViews.count * 65))
        }
    }
    
    private func setupCheckoutButton() {
        checkoutButton.configuration = .filled()
        
        var container = AttributeContainer()
        container.font = Resources.Font.Details.checkoutButton
        let string = AttributedString(Resources.Strings.Details.checkountButton, attributes: container)
        
        checkoutButton.configuration?.attributedTitle = string
        checkoutButton.configuration?.titleAlignment = .center
        checkoutButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.blue
        checkoutButton.configuration?.baseForegroundColor = AppColors.Buttons.Icon.whiteIcon
        checkoutButton.configuration?.cornerStyle = .capsule
        checkoutButton.addTarget(self, action: #selector(checkountButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(checkoutButton)
        checkoutButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupTotalAmountLabel() {
        totalAmountLabel.text = Resources.Strings.Details.totalAmountLabel
        totalAmountLabel.font = Resources.Font.Details.totalAmount
        totalAmountLabel.textColor = AppColors.Labels.darkBlue
        totalAmountLabel.textAlignment = .left
        
        addSubview(totalAmountLabel)
        totalAmountLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.bottom.equalTo(checkoutButton.snp_topMargin).inset(-30)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
    }
    
    private func setupTotalCostLabel() {
        totalCostLabel.text = "$\(Float(coffeeProduct.price))"
        totalCostLabel.font = Resources.Font.Details.totalCostLabel
        totalCostLabel.textColor = AppColors.Labels.darkBlue
        totalCostLabel.textAlignment = .right
        
        addSubview(totalCostLabel)
        totalCostLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.bottom.equalTo(totalAmountLabel)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
}

// MARK: - Actions
extension DetailView {
    @objc private func cartButtonAction(sender: UIButton) {
        delegate?.didTappedCartButton()
    }
    
    @objc private func checkountButtonAction(sender: UIButton) {
        delegate?.didTappedCheckoutButton()
    }
    
    @objc private func backArrowButtonAction(sender: UIButton) {
        delegate?.didTappedBackArrowButton()
    }
}

// MARK: - QuanitySectionViewDelegate
extension DetailView: QuanitySectionViewDelegate {
    func updateQuanity(count: Int) {
        delegate?.didQuanityChange(for: count)
    }
}

// MARK: - ShotSectionViewDelegate
extension DetailView: ShotSectionViewDelegate {
    func updateShotType(for type: EspressoShot) {
        delegate?.didShotChange(for: type)
    }
}

// MARK: - TemperatureSectionViewDelegate
extension DetailView: TemperatureSectionViewDelegate {
    func updateTemperatureType(for type: TemperatureType) {
        delegate?.didTemperatureTypeChange(for: type)
    }
}

// MARK: - CupSizeSectioniewDelegate
extension DetailView: CupSizeSectioniewDelegate {
    func updateCupSizeType(for type: CupSize) {
        delegate?.didCupSizeChange(for: type)
    }
}

// MARK: - IceAmountSectionViewDelegate
extension DetailView: IceAmountSectionViewDelegate {
    func updateIceAmountType(for type: IceAmount) {
        delegate?.didIceAmountChange(for: type)
    }
}
