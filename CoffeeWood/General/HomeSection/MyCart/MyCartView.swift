import Foundation
import UIKit
import SnapKit

enum CartFullType {
    case empty
    case full
}

protocol MyCartViewDelegate: AnyObject {
    func didTappedCheckoutButton()
    func willShowCartPositions()
    func didDeleteCell(at index: Int)
    func didTappedBackArrowButton()
    func didFinishPresentCartPositions()
}

class MyCartView: UIView {
    
    weak var delegate: MyCartViewDelegate?
    
    private var dataSource = [CartPosition]()
    
    private let myCartLabel = UILabel()
    private let productsTableView = UITableView(frame: .zero, style: .grouped)
    private let totalPriceLbael = UILabel()
    private let totalCostLabel = UILabel()
    private let bottomButton = UIButton()
    private let backArrowButton = UIButton()
    private let emptyCartImageView = UIImageView()
    
    init(delegate: MyCartViewDelegate) {
        self.delegate = delegate
        delegate.willShowCartPositions()
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print("MyCartView is dead")
    }
    
    // MARK: - Internal Methods
    func presentCartPositions(_ positions: [CartPosition]) {
        self.dataSource = positions
        
        DispatchQueue.main.async {
            self.productsTableView.reloadData()
            self.totalCostLabel.text = (positions.reduce(0.0) {$0 + $1.cost}).makeMePrice()
            self.delegate?.didFinishPresentCartPositions()
        }
    }
    
    func updateForEmptyCart() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.2,
                           options: [.curveEaseInOut]) {
                self.setupBottomButtonForEmptyCart()
                self.totalCostLabel.isHidden = true
                self.totalPriceLbael.isHidden = true
                self.productsTableView.isHidden = true
                self.layoutIfNeeded()
                
            } completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.emptyCartImageView.alpha = 1
                } completion: { _ in
                    self.setupBottomButtonForEmptyCart()
                }
            }
        }
    }
}

// MARK: - Setup View
extension MyCartView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupBackArrowButton()
        setupMyCartLabel()
        setupTotalPriceLabel()
        setupTotalCostLabel()
        setupProductsTableView()
        setupBottomButton(for: .full)
        setupEmptyCartView(for: .full)
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
    
    private func setupMyCartLabel() {
        myCartLabel.text = Resources.Strings.MyCart.myCartLabel
        myCartLabel.textColor = AppColors.Labels.darkBlue
        myCartLabel.font = Resources.Font.MyCart.myCartLabel
        myCartLabel.textAlignment = .left
        
        addSubview(myCartLabel)
        myCartLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.top.equalToSuperview().inset(110)
            make.width.equalTo(90)
            make.height.equalTo(25)
        }
    }
    
    private func setupTotalPriceLabel() {
        totalPriceLbael.text = Resources.Strings.MyCart.totalPriceLabel
        totalPriceLbael.textColor = AppColors.Labels.lightGray
        totalPriceLbael.font = Resources.Font.MyCart.totalPriceLabel
        totalPriceLbael.textAlignment = .left
        
        addSubview(totalPriceLbael)
        totalPriceLbael.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.bottom.equalToSuperview().inset(72)
            make.width.equalTo(130)
            make.height.equalTo(20)
        }
    }
    
    private func setupTotalCostLabel() {
        totalCostLabel.text = 0.0.makeMePrice()
        totalCostLabel.textColor = AppColors.Labels.darkBlue
        totalCostLabel.font = Resources.Font.MyCart.totalCostLabel
        totalCostLabel.textAlignment = .left
        
        addSubview(totalCostLabel)
        totalCostLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.top.equalTo(totalPriceLbael.snp_bottomMargin).inset(-16)
            make.width.equalTo(130)
            make.height.equalTo(20)
        }
    }
    
    private func setupProductsTableView() {
        let headerView = UIView(frame: .init(x: 0, y: 0, width: self.frame.width - 50, height: 14))
        headerView.backgroundColor = .systemBackground

        productsTableView.backgroundColor = .systemBackground
        productsTableView.separatorColor = .systemBackground
        
        productsTableView.showsVerticalScrollIndicator = false
        productsTableView.allowsSelection = false
        productsTableView.tableHeaderView = headerView
        
        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartTableViewCell")
        
        productsTableView.rowHeight = 120
        
        addSubview(productsTableView)
        productsTableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(myCartLabel).inset(30)
            make.bottom.equalTo(totalPriceLbael).inset(30)
        }
    }
    
    private func setupBottomButton(for type: CartFullType) {
        bottomButton.configuration = .filled()
        
        let image = Resources.Images.MyCart.checkoutButton?.withTintColor(.white)
    
        bottomButton.configuration?.image = image
        bottomButton.configuration?.imagePadding = 10
        bottomButton.configuration?.imagePlacement = .leading
        bottomButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.blue
        bottomButton.configuration?.baseForegroundColor = AppColors.Buttons.Icon.whiteIcon
        bottomButton.configuration?.cornerStyle = .capsule
        bottomButton.addTarget(self, action: #selector(checkountButtonAction(sender:)), for: .touchUpInside)
        
        switch type {
        case .empty:
            setupBottomButtonForEmptyCart()
        case .full:
            setupBottomButtonForFullType()
        }
    }
    
    private func setupBottomButtonForEmptyCart() {
        var container = AttributeContainer()
        container.font = Resources.Font.Details.checkoutButton
        let string = AttributedString("To shopping menu", attributes: container)
        self.bottomButton.configuration?.attributedTitle = string
        bottomButton.configuration?.titleAlignment = .center
        
        self.bottomButton.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(54)
        }
    }
    
    private func setupBottomButtonForFullType() {
        var container = AttributeContainer()
        container.font = Resources.Font.Details.checkoutButton
        let string = AttributedString(Resources.Strings.Details.checkountButton, attributes: container)
        bottomButton.configuration?.attributedTitle = string
        bottomButton.configuration?.titleAlignment = .center
        
        addSubview(bottomButton)
        bottomButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(54)
            make.width.equalTo(160)
        }
    }
    
    private func setupEmptyCartView(for type: CartFullType) {
        addSubview(emptyCartImageView)
        emptyCartImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(60)
            make.height.equalTo(150)
        }
        
        emptyCartImageView.image = UIImage(named: "emptyCart")
        emptyCartImageView.contentMode = .scaleAspectFit
        emptyCartImageView.alpha = 0
        
        switch type {
        case .empty:
            emptyCartImageView.alpha = 1
        case .full:
            emptyCartImageView.alpha = 0
        }
    }
}

// MARK: - Actions
extension MyCartView {
    @objc private func checkountButtonAction(sender: UIButton) {
        delegate?.didTappedCheckoutButton()
    }
    
    @objc private func backArrowButtonAction(sender: UIButton) {
        delegate?.didTappedBackArrowButton()
    }
}

// MARK: - UITableViewDataSource
extension MyCartView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            fatalError()
        }
        
        cell.configureCell(with: dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyCartView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (contextualAction, view, actionPerformed: (Bool) -> Void) in
            self.delegate?.didDeleteCell(at: indexPath.row)
        }
        delete.backgroundColor = .systemBackground
        delete.image = UIImage(named: "deletePosition")!
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
