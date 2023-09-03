import Foundation
import UIKit
import SnapKit

protocol CustomStepperDelegate: AnyObject {
    func updateCount(count: Int)
}

class CustomStepper: UIView {
    
    weak var delegate: CustomStepperDelegate?
    
    let minusButton = UIButton()
    let plusButton = UIButton()
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func getCount() -> Int {
        let count = 0
        guard let text = countLabel.text else { return count }
        if let count = Int(text) {
            return count
        }
        return count
    }
    
    private func setupView() {
        [minusButton, plusButton, countLabel].forEach { view in
            addSubview(view)
        }
        
        setupCountLabel()
        setupMinusButton()
        setupPlusButton()
    }
    
    private func setupCountLabel() {
        countLabel.text = "1"
        countLabel.font = UIFont(name: "DMSans-Medium", size: 15)
        countLabel.textAlignment = .center
        countLabel.textColor = AppColors.Labels.darkBlue
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }
    
    private func setupMinusButton() {
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont(name: "DMSans-Medium", size: 15)
        minusButton.setTitleColor(AppColors.Buttons.TextButton.darkBlue, for: .normal)
        minusButton.setTitleColor(.systemGray3, for: .highlighted)
        minusButton.addTarget(self, action: #selector(minusButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(countLabel.snp_leftMargin).inset(-3)
            make.height.width.equalTo(22)
        }
    }
    
    private func setupPlusButton() {
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont(name: "DMSans-Medium", size: 15)
        plusButton.setTitleColor(AppColors.Buttons.TextButton.darkBlue, for: .normal)
        plusButton.setTitleColor(.systemGray3, for: .highlighted)
        plusButton.addTarget(self, action: #selector(plusButtonAction(sender: )), for: .touchUpInside)
        
        addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(countLabel.snp_rightMargin).inset(-3)
            make.height.width.equalTo(22)
        }
    }
    
    @objc private func minusButtonAction(sender: UIButton) {
        if getCount() > 1 {
            countLabel.text = "\(getCount() - 1)"
        }
        delegate?.updateCount(count: getCount())
    }
    
    @objc private func plusButtonAction(sender: UIButton) {
        if getCount() < 10 {
            countLabel.text = "\(getCount() + 1)"
        }
        delegate?.updateCount(count: getCount())
    }
}
