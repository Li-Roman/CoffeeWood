import Foundation
import UIKit
import SnapKit

enum OrderChosingInfoType {
    case address
    case time
    
    func getImageViewImage() -> UIImage {
        switch self {
        case .address:
            return Resources.Images.OrderConfirmation.addressImage!
        case .time:
            let config = UIImage.SymbolConfiguration(pointSize: 25)
            let image = Resources.Images.OrderConfirmation.workingHoursImage!
                        .withConfiguration(config)
            return image
        }
    }
}

protocol OrderChosingSectionViewDelegate: AnyObject {
    func didTapToAddressChosingView(with type: OrderChosingInfoType)
}

class OrderChosingSectionView: UIView {
    
    weak var delegate: OrderChosingSectionViewDelegate?
    
    private let type: OrderChosingInfoType
    
    private let backView = UIView()
    private let imageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let editImageView = UIImageView()
    
    init(type: OrderChosingInfoType) {
        print("init OrderChosingSectionView")
        self.type = type
        super.init(frame: .zero)
        setupView()
        setupGestureRecognisers()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - InternalMethods
    func configureData(mainLabelText: String? = nil, subLabelText: String? = nil) {
        print("Configure data in OrderChosingSectionView")
        if let mainLabelText = mainLabelText {
            mainLabel.text = mainLabelText
            print("mainLabel.text = \(mainLabel.text!)")
        }
        if let subLabelText = subLabelText {
            subLabel.text = subLabelText
            print("subLabel.text = \(subLabel.text!)")
        }
    }
    
    // MARK: - Private Methods
    private func setupGestureRecognisers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
}

// MARK: - Seetup View
extension OrderChosingSectionView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        setupImageBackView()
        setupImageView()
        setupMainLabel()
        setupSubLabel()
        setupEditImageView()
    }
    
    private func setupImageBackView() {
        addSubview(backView)
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.height.width.equalTo(42)
        }
        backView.backgroundColor = AppColors.Background.grayBack
        backView.layer.cornerRadius = 12
        backView.clipsToBounds = true
    }
    
    private func setupImageView() {
        backView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        imageView.image = self.type.getImageViewImage()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = AppColors.Buttons.Back.darkBlue
    }
    
    private func setupMainLabel() {
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp_topMargin).inset(-4)
            make.left.equalTo(backView.snp_rightMargin).inset(-20)
            make.height.equalTo(16)
            make.right.equalToSuperview().inset(10)
        }
        
        mainLabel.font = Resources.Font.OrderConfirmation.addressLabel
        mainLabel.textColor = AppColors.Labels.darkBlue
        mainLabel.numberOfLines = 1
    }
    
    private func setupSubLabel() {
        addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.right.height.equalTo(mainLabel)
            make.top.equalTo(mainLabel.snp_bottomMargin).inset(-12)
        }

        subLabel.font = Resources.Font.OrderConfirmation.workingHoursLabel
        subLabel.textColor = AppColors.Labels.gray
        subLabel.numberOfLines = 1
    }
    
    private func setupEditImageView() {
        editImageView.image = UIImage(named: "Edit")
        editImageView.contentMode = .scaleAspectFit
        
        addSubview(editImageView)
        editImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
    }
}

// MARK: - Actions
extension OrderChosingSectionView {
    @objc private func tapAction() {
        print("Tap on AddressChosingView")
        delegate?.didTapToAddressChosingView(with: self.type)
    }
}

