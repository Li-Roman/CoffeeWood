import Foundation
import UIKit

class CircleNextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
}

//MARK: - Internal Methods
extension CircleNextButton {
    func setupButtonImage(size: CGFloat = 20) {
        let config = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: "arrow.right")!.withConfiguration(config)
        
        configuration?.image = image.withTintColor(AppColors.Buttons.Icon.whiteIcon)
        
    }
}

// MARK: - SetupView
extension CircleNextButton {
    private func setupButton() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        configuration?.baseBackgroundColor = AppColors.Buttons.Back.blue
        setupButtonImage()
        makeShadow()
    }
    
    private func makeShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.25
    }
}
