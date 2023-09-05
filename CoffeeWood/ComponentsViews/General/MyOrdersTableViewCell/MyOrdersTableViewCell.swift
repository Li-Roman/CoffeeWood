import Foundation
import UIKit
import SnapKit

class MyOrdersTableViewCell: UITableViewCell {
    
    private let dateLabel = UILabel()
    private let productsLabel = UILabel()
    private let addressLabel = UILabel()
    private let totalCostLabel = UILabel()
    private let productImageView = UIImageView()
    private let geopointImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCell(with order: Order) {
        var products = [String]()
        order.cartPositions.forEach { position in
            products.append(position.productTitle.capitalized)
        }
        
        dateLabel.text = order.date.makeMeAppDateStyle()
        addressLabel.text = order.address
        totalCostLabel.text = order.cost.makeMePrice()
        productsLabel.text = products.joined(separator: ", ")
    }
}

// MARK: - Setup View
extension MyOrdersTableViewCell {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupDateLabel()
        setupProductImageView()
        setupGeopointImageView()
        setupproductsLabel()
        setupAddressLabel()
        setupTotalCostLabel()
    }
    
    private func setupDateLabel() {
        dateLabel.font = Resources.Font.OrdersTableView.dateLabel
        dateLabel.textColor = AppColors.Labels.lightGray
        dateLabel.textAlignment = .left
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(15)
            make.width.equalTo(100)
        }
    }
    
    private func setupProductImageView() {
        productImageView.image = Resources.Images.OrdersTableView.coffeeCup
        productImageView.contentMode = .scaleAspectFit
        productImageView.tintColor = AppColors.Lines.lightBlue
        
        addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dateLabel.snp_bottomMargin).inset(-18)
            make.height.width.equalTo(14)
        }
    }
    
    private func setupGeopointImageView() {
        geopointImageView.image = Resources.Images.OrdersTableView.geoPoint
        geopointImageView.contentMode = .scaleAspectFit
        geopointImageView.tintColor = AppColors.Lines.lightBlue
        
        addSubview(geopointImageView)
        geopointImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(productImageView.snp_bottomMargin).inset(-18)
            make.height.width.equalTo(14)
        }
    }
    
    private func setupproductsLabel() {
        productsLabel.font = Resources.Font.OrdersTableView.productNameLabel
        productsLabel.textColor = AppColors.Labels.blue
        productsLabel.textAlignment = .left
        productsLabel.numberOfLines = 1
        
        addSubview(productsLabel)
        productsLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp_rightMargin).inset(-20)
            make.centerY.equalTo(productImageView)
            make.height.equalTo(productImageView)
            make.width.equalToSuperview().inset(20)
        }
    }
    
    private func setupAddressLabel() {
        addressLabel.font = Resources.Font.OrdersTableView.addressLabel
        addressLabel.textColor = AppColors.Labels.blue
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 1
        
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(geopointImageView.snp_rightMargin).inset(-20)
            make.centerY.equalTo(geopointImageView)
            make.height.equalTo(geopointImageView)
            make.width.equalToSuperview().inset(20)
        }
    }
    
    private func setupTotalCostLabel() {
        totalCostLabel.font = Resources.Font.OrdersTableView.productsCostLabel
        totalCostLabel.textColor = AppColors.Labels.blue
        totalCostLabel.textAlignment = .right
        totalCostLabel.numberOfLines = 1
        
        addSubview(totalCostLabel)
        totalCostLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.right.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(70)
        }
    }
}
