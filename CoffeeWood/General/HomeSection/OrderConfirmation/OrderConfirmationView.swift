//
//  OrderConfirmationView.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol OrderConfirmationViewDelegate: AnyObject {
    func didTappedPayNowButton()
}

class OrderConfirmationView: UIView {
 
    weak var delegate: OrderConfirmationViewDelegate?
    
    private let orderConfirmationLabel = UILabel()
    private let usernameLabel = UILabel()
    private let deliveryAddressLabel = UILabel()
    private let deliveryImageView = UIImageView()
    private let addressTextView = UITextView()
    private let editAddressButton = UIButton()
    private let onlineBankingView = BankPaymentView()
    private let creditCardView = BankPaymentView()
    private let subtotalLabel = UILabel()
    private let subtotalCostLabel = UILabel()
    private let taxLabel = UILabel()
    private let taxCostLabel = UILabel()
    private let deliveryFeeLabel = UILabel()
    private let deliveryFeeCostLabel = UILabel()
    private let totalPriceeLabel = UILabel()
    private let totalCostLabel = UILabel()
    private let payNowButton = UIButton()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Setup View
extension OrderConfirmationView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupOrderConfirmationLabel()
        setupPayNowButton()
    }
    
    private func setupOrderConfirmationLabel() {
        orderConfirmationLabel.text = Resources.Strings.OrderConfirmation.orderConfirmationLabel
        orderConfirmationLabel.font = Resources.Font.OrderConfirmation.orderConfirmationLabel
        orderConfirmationLabel.textColor = AppColors.Labels.darkBlue
        
        addSubview(orderConfirmationLabel)
        orderConfirmationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(32)
            make.top.equalToSuperview().inset(35)
            make.width.equalTo(220)
            make.height.equalTo(25)
        }
    }
    
    private func setupPayNowButton() {
        payNowButton.configuration = .filled()
        
        var container = AttributeContainer()
        container.font = Resources.Font.OrderConfirmation.payNowButton
        let string = AttributedString(Resources.Strings.OrderConfirmation.payNowButton, attributes: container)
        
        let image = Resources.Images.OrderConfirmation.paymentImage?.withTintColor(.white)
        
        payNowButton.configuration?.attributedTitle = string
        payNowButton.configuration?.titleAlignment = .center
        payNowButton.configuration?.image = image
        payNowButton.configuration?.imagePadding = 15
        payNowButton.configuration?.imagePlacement = .leading
        payNowButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.blue
        payNowButton.configuration?.baseForegroundColor = AppColors.Buttons.Icon.whiteIcon
        payNowButton.configuration?.cornerStyle = .capsule
        payNowButton.addTarget(self, action: #selector(payNowButtonAction(sender:)), for: .touchUpInside)
        
        addSubview(payNowButton)
        payNowButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(54)
            make.width.equalTo(160)
        }
    }
    
}

extension OrderConfirmationView {
    @objc private func payNowButtonAction(sender: UIButton) {
        print("pay now button did tapped")
        delegate?.didTappedPayNowButton()
    }
}
