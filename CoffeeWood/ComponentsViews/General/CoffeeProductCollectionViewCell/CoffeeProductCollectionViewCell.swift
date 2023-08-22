//
//  CoffeeProductCell.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 07.08.2023.
//

import Foundation
import UIKit
import SnapKit

class CoffeeProductCollectionViewCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupCell() {
        self.layer.cornerRadius = 15
        backgroundColor = .white
        
        self.clipsToBounds = true
        
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalToSuperview().inset(30)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = AppColors.Labels.darkBlue
        titleLabel.font = Resources.Font.HomePage.coffeeProduct
        titleLabel.text = "Coffee"
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).inset(50)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalToSuperview().inset(16)
        }
    }
    
    func configureCell(with coffeeProduct: CoffeeProduct) {
        imageView.image = coffeeProduct.image
        titleLabel.text = coffeeProduct.title.capitalized
    }
}
