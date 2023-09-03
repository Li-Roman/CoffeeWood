import Foundation
import UIKit

class CartTableViewCell: UITableViewCell {
    
    private let tableCellBackView = UIView()
    private let productImageView = UIImageView()
    private let productNameLabel = UILabel()
    private let productDescriptionLabel = UILabel()
    private let productPriceLabel = UILabel()
    private let productsCountLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configureCell(with cartPosition: CartPosition) {
        productImageView.image = cartPosition.productImage
        productNameLabel.text = cartPosition.productTitle.capitalized
        productPriceLabel.text = "$\(cartPosition.cost)0"
        productsCountLabel.text = "x \(cartPosition.count)"
        
        let esppressoShotText = cartPosition.espressoCount
        let temperatureText = cartPosition.temperatureType
        let cupSizeText = cartPosition.cupSize
        let iceamountText = cartPosition.iceAmount
        productDescriptionLabel.text = "\(esppressoShotText) | \(temperatureText) | \(cupSizeText) | \(iceamountText)"
    }
}

// MARK: -  Setup View
extension CartTableViewCell {
    private func setupView() {
        setupProductImageView()
        setupTableCellBackView()
        setupProductNameLabel()
        setupProductDescriptionLabel()
        setupProductPriceLabel()
        setupProductsCountLabel()
    }
    
    private func setupTableCellBackView() {
        tableCellBackView.backgroundColor = AppColors.Background.grayBack
        tableCellBackView.layer.cornerRadius = 15
        tableCellBackView.clipsToBounds = true
        
        addSubview(tableCellBackView)
        tableCellBackView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(14)
            make.left.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        
        tableCellBackView.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(6)
            make.width.equalTo(80)
        }
    }
    
    private func setupProductNameLabel() {
        productNameLabel.font = Resources.Font.CartTableView.productNameLabel
        productNameLabel.textColor = AppColors.Labels.darkBlue
        productNameLabel.textAlignment = .left
        
        tableCellBackView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp_rightMargin).inset(-16)
            make.top.equalToSuperview().inset(18)
            make.height.equalTo(18)
            make.width.equalTo(110)
        }
    }
    
    private func setupProductDescriptionLabel() {
        productDescriptionLabel.font = Resources.Font.CartTableView.productDescriptionLabel
        productDescriptionLabel.textColor = AppColors.Labels.darktGray
        productDescriptionLabel.textAlignment = .left
        
        tableCellBackView.addSubview(productDescriptionLabel)
        productDescriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp_rightMargin).inset(-16)
            make.top.equalTo(productNameLabel.snp_bottomMargin).inset(-12)
            make.height.equalTo(18)
            make.right.equalTo(170)
        }
    }
    
    private func setupProductPriceLabel() {
        productPriceLabel.font = Resources.Font.CartTableView.productPriceLabel
        productPriceLabel.textAlignment = .right
        productPriceLabel.textColor = AppColors.Labels.darkBlue
        
        tableCellBackView.addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
    }
    
    private func setupProductsCountLabel() {
        productsCountLabel.font = Resources.Font.CartTableView.productsCountLabel
        productsCountLabel.textAlignment = .left
        productsCountLabel.textColor = AppColors.Labels.darktGray
        
        tableCellBackView.addSubview(productsCountLabel)
        productsCountLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp_rightMargin).inset(-16)
            make.top.equalTo(productDescriptionLabel.snp_bottomMargin).inset(-12)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
}

