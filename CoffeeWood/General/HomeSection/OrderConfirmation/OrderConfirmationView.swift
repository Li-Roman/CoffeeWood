import Foundation
import UIKit
import SnapKit

enum CustomResultType {
    case success
    case failure
}

protocol OrderConfirmationViewDelegate: AnyObject {
    func willShowTotalCostSection()
    func willShowCoffeeHouseAddress()
    func willShowPickupTime()
    func didTappedPayNowButton()
    func didTappedEditAddress()
    func didTappedEditPickupTime()
}

class OrderConfirmationView: UIView {
 
    weak var delegate: OrderConfirmationViewDelegate?
    
    private let orderConfirmationLabel = UILabel()
    private let chooseAddressAndTimeLabel = UILabel()
    private let chooseAddressView = OrderChosingSectionView(type: .address)
    private let chooseTimeView = OrderChosingSectionView(type: .time)
    private let onlineBankingView = BankPaymentView(type: .onlineBanking)
    private let creditCardView = BankPaymentView(type: .creditCard)
    private let subtotalLabel = UILabel()
    private let subtotalCostLabel = UILabel()
    private let taxLabel = UILabel()
    private let taxCostLabel = UILabel()
    private let totalPriceLabel = UILabel()
    private let totalCostLabel = UILabel()
    private let payNowButton = UIButton()
    private var progressCircle: UIActivityIndicatorView = {
        let progressCircle = UIActivityIndicatorView(style: .medium)
        progressCircle.color = .white
        return progressCircle
    }()
    

    init(delegate: OrderConfirmationViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
        delegate?.willShowCoffeeHouseAddress()
        delegate?.willShowTotalCostSection()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Internal Methods
    func setTotalcostSectionWith(totalCost: Double, subtotalCost: Double, taxCost: Double) {
        DispatchQueue.main.async {
            self.totalCostLabel.text = totalCost.makeMePrice()
            self.taxCostLabel.text = taxCost.makeMePrice()
            self.subtotalCostLabel.text = subtotalCost.makeMePrice()
        }
    }
    
    func setChosingAddress(address: String, openTodayText: String) {
        DispatchQueue.main.async {
            self.chooseAddressView.configureData(mainLabelText: address,
                                            subLabelText: openTodayText)
        }
    }
    
    func setChosingTime(time: String) {
        DispatchQueue.main.async {
            self.chooseTimeView.configureData(mainLabelText: "Pickup time", subLabelText: time)
        }
    }
    
    func getAddressSectionView() -> UIView {
        return chooseAddressView
    }
    
    func startAnimatePayButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.payNowButton.configuration?.attributedTitle = ""
                self.payNowButton.configuration?.image = nil
                self.payNowButton.snp.makeConstraints { make in
                    make.right.equalToSuperview().inset(30)
                    make.bottom.equalToSuperview().inset(30)
                    make.height.equalTo(54)
                    make.width.equalTo(54)
                }
                self.payNowButton.addSubview(self.progressCircle)
                self.progressCircle.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                self.layoutIfNeeded()
                
            } completion: { _ in
                self.payNowButton.configuration?.attributedTitle = ""
                self.payNowButton.configuration?.image = nil
                self.progressCircle.startAnimating()
            }
        }
    }
    
    func stopAnimateButton(with result: CustomResultType, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.progressCircle.stopAnimating()
                UIView.animate(withDuration: 0.5) {
                    
                    let config = UIImage.SymbolConfiguration(pointSize: 14)
                    let image = result == .success ? UIImage(systemName: "checkmark")?.withConfiguration(config) : UIImage(systemName: "xmark")?.withConfiguration(config)
                    self.payNowButton.configuration?.image = image
                } completion: { _ in
                    completion()
                }
            }
        }
    }
}

// MARK: - Setup View
extension OrderConfirmationView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupOrderConfirmationLabel()
        setupPayNowButton()
        setupChooseAddressAndTimeLabel()
        setupChooseAddressView()
        setupChooseTimeView()
        setupOnlineBankingView()
        setupCreditCardView()
        setupSubtotalLabel()
        setupSubtotalCostLabel()
        setupTaxLabel()
        setupTaxCostLabel()
        setupTotalPriceLabel()
        setupTotalCostLabel()
    }
    
    private func setupOrderConfirmationLabel() {
        orderConfirmationLabel.text = Resources.Strings.OrderConfirmation.orderConfirmationLabel
        orderConfirmationLabel.font = Resources.Font.OrderConfirmation.orderConfirmationLabel
        orderConfirmationLabel.textColor = AppColors.Labels.darkBlue
        
        addSubview(orderConfirmationLabel)
        orderConfirmationLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(35)
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
    
    private func setupChooseAddressAndTimeLabel() {
        chooseAddressAndTimeLabel.text = Resources.Strings.OrderConfirmation.chooseAddressAndTimaLabel
        chooseAddressAndTimeLabel.font = Resources.Font.OrderConfirmation.chooseAddressAndTimaLabel
        chooseAddressAndTimeLabel.textColor = AppColors.Labels.darkBlue
        
        addSubview(chooseAddressAndTimeLabel)
        chooseAddressAndTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(orderConfirmationLabel.snp_bottomMargin).inset(-40)
            make.left.equalTo(orderConfirmationLabel)
            make.height.equalTo(20)
            make.width.equalTo(220)
        }
    }
    
    private func setupChooseAddressView() {
        chooseAddressView.delegate = self
        
        addSubview(chooseAddressView)
        chooseAddressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(chooseAddressAndTimeLabel.snp_bottomMargin).inset(-30)
            make.height.equalTo(44)
        }
    }
    
    private func setupChooseTimeView() {
        chooseTimeView.delegate = self
        
        addSubview(chooseTimeView)
        chooseTimeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(chooseAddressView.snp_bottomMargin).inset(-20)
            make.height.equalTo(44)
        }
    }
    
    private func setupOnlineBankingView() {
        onlineBankingView.delegate = self
        onlineBankingView.selectedSwitch(for: true)
        onlineBankingView.layer.cornerRadius = 12
        onlineBankingView.clipsToBounds = true
        
        addSubview(onlineBankingView)
        onlineBankingView.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(30)
            make.top.equalTo(chooseTimeView.snp_bottomMargin).inset(-30)
            make.height.equalTo(80)
        }
    }
    
    private func setupCreditCardView() {
        creditCardView.delegate = self
        creditCardView.layer.cornerRadius = 12
        creditCardView.clipsToBounds = true
        
        addSubview(creditCardView)
        creditCardView.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(30)
            make.top.equalTo(onlineBankingView.snp_bottomMargin).inset(-20)
            make.height.equalTo(80)
        }
    }
    
    private func setupSubtotalLabel() {
        subtotalLabel.text = Resources.Strings.OrderConfirmation.subtotalLabel
        subtotalLabel.font = Resources.Font.OrderConfirmation.subtotalLabel
        subtotalLabel.textColor = AppColors.Labels.darkBlue
        subtotalLabel.textAlignment = .left
        
        addSubview(subtotalLabel)
        subtotalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.top.equalTo(creditCardView.snp_bottomMargin).inset(-50)
            make.width.equalTo(100)
            make.height.equalTo(16)
        }
    }
    
    private func setupSubtotalCostLabel() {
        subtotalCostLabel.font = Resources.Font.OrderConfirmation.subtotalCostLabel
        subtotalCostLabel.textColor = AppColors.Labels.darkBlue
        subtotalCostLabel.textAlignment = .right
        
        addSubview(subtotalCostLabel)
        subtotalCostLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.top.equalTo(subtotalLabel)
            make.width.equalTo(subtotalLabel)
            make.height.equalTo(subtotalLabel)
        }
    }
    
    private func setupTaxLabel() {
        taxLabel.text = Resources.Strings.OrderConfirmation.taxLabel
        taxLabel.font = Resources.Font.OrderConfirmation.taxLabel
        taxLabel.textColor = AppColors.Labels.darkBlue
        taxLabel.textAlignment = .left
        
        addSubview(taxLabel)
        taxLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(30)
            make.top.equalTo(subtotalLabel.snp_bottomMargin).inset(-30)
            make.width.equalTo(100)
            make.height.equalTo(16)
        }
    }
    
    private func setupTaxCostLabel() {
        taxCostLabel.font = Resources.Font.OrderConfirmation.taxCostLabel
        taxCostLabel.textColor = AppColors.Labels.darkBlue
        taxCostLabel.textAlignment = .right
        
        addSubview(taxCostLabel)
        taxCostLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.top.equalTo(taxLabel)
            make.width.equalTo(taxLabel)
            make.height.equalTo(taxLabel)
        }
    }
    
    private func setupTotalPriceLabel() {
        totalPriceLabel.text = Resources.Strings.OrderConfirmation.totalPriceLabel
        totalPriceLabel.textColor = AppColors.Labels.lightGray
        totalPriceLabel.font = Resources.Font.OrderConfirmation.totalPriceLabel
        totalPriceLabel.textAlignment = .left
        
        addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.bottom.equalToSuperview().inset(72)
            make.width.equalTo(130)
            make.height.equalTo(20)
        }
    }
    
    private func setupTotalCostLabel() {
        totalCostLabel.textColor = AppColors.Labels.darkBlue
        totalCostLabel.font = Resources.Font.OrderConfirmation.totalCostLabel
        totalCostLabel.textAlignment = .left
        
        addSubview(totalCostLabel)
        totalCostLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.top.equalTo(totalPriceLabel.snp_bottomMargin).inset(-16)
            make.width.equalTo(130)
            make.height.equalTo(20)
        }
    }
}

// MARK: - Actions
extension OrderConfirmationView {
    @objc private func payNowButtonAction(sender: UIButton) {
        delegate?.didTappedPayNowButton()
    }
}

// MARK: - AddressChosingViewDelegate
extension OrderConfirmationView: OrderChosingSectionViewDelegate {
    func didTapToAddressChosingView(with type: OrderChosingInfoType) {
        switch type {
        case .address:
            delegate?.didTappedEditAddress()
        case .time:
            delegate?.didTappedEditPickupTime()
        }
    }
}

extension OrderConfirmationView: BankPaymentViewDelegate {
    func didTapToBankPaymentView(for type: PaymentType) {
        switch type {
        case .creditCard:
            creditCardView.selectedSwitch(for: true)
            onlineBankingView.selectedSwitch(for: false)
        case .onlineBanking:
            creditCardView.selectedSwitch(for: false)
            onlineBankingView.selectedSwitch(for: true)
        }
    }
}
