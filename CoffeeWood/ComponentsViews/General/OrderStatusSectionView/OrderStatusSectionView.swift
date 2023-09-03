import Foundation
import UIKit
import SnapKit

class OrderStatusSectionView: UIView {

    private let bottomDots: Bool
    private let backColor: UIColor
    private let image: UIImage
    private let labelText: String
    private let labelFont: UIFont
    
    private let imageBackView = UIView()
    private let imageView = UIImageView()
    private let sectionLabel = UILabel()
    private var dotsStackView = UIStackView()
    
    init(with bottomDots: Bool,
         color: UIColor,
         image: UIImage,
         labelText: String,
         labelFont: UIFont) {
        
        self.bottomDots = bottomDots
        self.backColor = color
        self.image = image
        self.labelText = labelText
        self.labelFont = labelFont
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func makeDot(view: UIView, with color: UIColor) {
        let view = view
        let dotView = UIView()
        view.addSubview(dotView)
        dotView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(5)
        }
        
        dotView.backgroundColor = color
        dotView.layer.cornerRadius = 2.5
        dotView.clipsToBounds = true
    }
}

// MARK: - Setup View
extension OrderStatusSectionView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupImageBackView()
        setupImageView()
        setupSectionLabel()
        if self.bottomDots == true {
            setupDotsStackView()
        }
    }

    private func setupImageBackView() {
        addSubview(imageBackView)
        imageBackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(24)
            make.height.width.equalTo(36)
        }
        
        imageBackView.backgroundColor = self.backColor
        imageBackView.layer.cornerRadius = 18
        imageBackView.clipsToBounds = true
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalTo(imageBackView)
            make.height.width.equalTo(16)
        }
        imageView.backgroundColor = .clear
        imageView.image = self.image
        imageView.contentMode = .scaleAspectFit
        
        setupSectionLabel()
    }
    
    private func setupSectionLabel() {
        sectionLabel.text = self.labelText
        sectionLabel.font = self.labelFont
        sectionLabel.textColor = AppColors.Labels.darkBlue
        
        addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageBackView)
            make.left.equalTo(imageBackView.snp_rightMargin).inset(-26)
            make.right.equalToSuperview().inset(30)
        }
    }
    
    private func setupDotsStackView() {
        let dots: [UIView] = [UIView(), UIView(), UIView()]

        dotsStackView = UIStackView(arrangedSubviews: dots)
        dots.forEach { view in
            makeDot(view: view, with: self.backColor)
        }
        
        addSubview(dotsStackView)
        dotsStackView.snp.makeConstraints { make in
            make.centerX.equalTo(imageBackView)
            make.height.equalTo(30)
            make.top.equalTo(imageBackView.snp_bottomMargin).inset(-12)
            make.width.equalTo(8)
        }
        
        dotsStackView.axis = .vertical
        dotsStackView.alignment = .fill
        dotsStackView.distribution = .equalSpacing
    }
}
