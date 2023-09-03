import Foundation
import UIKit
import SnapKit

enum orderStatusSection {
    case accept
    case preparing
    case complete
}

class OrderStatusView: UIView {
    
    private var activeOrder: Order? = nil
    
    private let emptyOrderImageView = UIImageView()
    private let emptyOrderLabel = UILabel()
    
    private var sectionStackView = UIStackView()
    private var acceptedSectionView: OrderStatusSectionView?
    private var preparingSectionView: OrderStatusSectionView?
    private var completeSectionView: OrderStatusSectionView?
    
    init(activeOrder: Order?) {
        self.activeOrder = activeOrder
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Internal Methods
    func updateView(activeOrder: Order?) {
        
        self.activeOrder = activeOrder
        setupView()
    }
    
    // MARK: - Private Methods
    private func getSectionColor(type: orderStatusSection) -> UIColor {
        switch type {
        case .preparing:
            return activeOrder?.status != .accepted ? AppColors.Background.blueBack : AppColors.Background.grayBack
        case .complete:
            return activeOrder?.status == .completed ? AppColors.Background.blueBack : AppColors.Background.grayBack
        default:
            return AppColors.Background.blueBack
        }
    }
    
    private func getCompleteText() -> String {
        activeOrder?.status == .completed ? "Complete" : "Estimated pickup time \(activeOrder!.pickupTime)"
    }
}

// MARK: - Setup View
extension OrderStatusView {
    private func setupView() {
        backgroundColor = .systemBackground
        
        if let _ = self.activeOrder {
            setupSectionStackView()
            sectionStackView.isHidden = false
            emptyOrderImageView.isHidden = true
            emptyOrderLabel.isHidden = true
        } else {
            setupViewForEmptyOrder()
            sectionStackView.isHidden = true
            emptyOrderImageView.isHidden = false
            emptyOrderLabel.isHidden = false
        }
    }
    
    private func setupAcceptedSection() {
        let image = Resources.Images.CoffeeHouseController.acceptedImageView!
        let color = AppColors.Background.blueBack
        let labelText = Resources.Strings.CoffeeHouseController.acceptedLabel
        let font = Resources.Font.CoffeeHouseController.acceptedLabel
        acceptedSectionView = OrderStatusSectionView(with: true,
                                                     color: color,
                                                     image: image,
                                                     labelText: labelText,
                                                     labelFont: font!)
    }
    
    private func setupPreparingSection() {
        let image = Resources.Images.CoffeeHouseController.preparingImageView!
        let color = getSectionColor(type: .preparing)
        let labelText = Resources.Strings.CoffeeHouseController.preparingLabel
        let font = Resources.Font.CoffeeHouseController.preparingLabel
        preparingSectionView = OrderStatusSectionView(with: true,
                                                     color: color,
                                                     image: image,
                                                     labelText: labelText,
                                                     labelFont: font!)
    }
    
    private func setupCompleteSectionView() {
        let image = Resources.Images.CoffeeHouseController.completedImageVIew!
        let color = getSectionColor(type: .complete)
        let labelText = getCompleteText()
        let font = Resources.Font.CoffeeHouseController.estimatedPickupLabel
        completeSectionView = OrderStatusSectionView(with: false,
                                                     color: color,
                                                     image: image,
                                                     labelText: labelText,
                                                     labelFont: font!)
    }
    
    private func setupSectionStackView() {
        setupAcceptedSection()
        setupPreparingSection()
        setupCompleteSectionView()
        
        let subViews = [acceptedSectionView!, preparingSectionView!, completeSectionView!]
        sectionStackView = UIStackView(arrangedSubviews: subViews)
        
        addSubview(sectionStackView)
        sectionStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.top.equalTo(22)
        }
        
        sectionStackView.axis = .vertical
        sectionStackView.alignment = .fill
        sectionStackView.distribution = .fillEqually
    }
        
    private func setupViewForEmptyOrder() {
        
        addSubview(emptyOrderImageView)
        emptyOrderImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview().inset(-10)
            make.height.width.equalTo(60)
        }
        
        emptyOrderImageView.contentMode = .scaleAspectFit
        emptyOrderImageView.image = Resources.Images.CoffeeHouseController.emptyOrderImageView?.withTintColor(AppColors.Labels.warmGray)
        emptyOrderImageView.tintColor = AppColors.Labels.warmGray
        
        addSubview(emptyOrderLabel)
        emptyOrderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(emptyOrderImageView.snp_topMargin).inset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        emptyOrderLabel.text = Resources.Strings.CoffeeHouseController.emptyOrderTitle
        emptyOrderLabel.font = Resources.Font.CoffeeHouseController.emptyOrderLabel
        emptyOrderLabel.textColor = AppColors.Labels.warmGray
        emptyOrderLabel.textAlignment = .center
    }
}
