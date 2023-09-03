import Foundation
import UIKit

class MainLabel: UILabel {

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    func makeMeOnbording(with text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
        textAlignment = .center
    }

    //MARK: - Setup View
    private func setupView() {
        textAlignment = .left
        numberOfLines = 2
        font = UIFont(name: "Poppins-Medium", size: 24)
        textColor = AppColors.Labels.darkBlue
    }
}
