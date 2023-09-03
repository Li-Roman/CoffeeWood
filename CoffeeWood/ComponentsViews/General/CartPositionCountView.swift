import Foundation
import UIKit
import SnapKit

protocol CartPositionsCountViewDelegate: AnyObject {
    func didTapAction()
}

class CartPositionsCountView: UIView {
    
    weak var delegate: CartPositionsCountViewDelegate?
    
    private let countLabel = UILabel()
    
    init(delegate: CartPositionsCountViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func updateCountNumber(for count: Int) {
        DispatchQueue.main.async {
            self.countLabel.text = "\(count)"
        }
    }
    
    // MARK: - Setup View
    private func setupView() {
        setupGestureRecognizer()
        backgroundColor = .systemRed
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.font = UIFont(name: "Poppins-SemiBold", size: 10)
    }
    
    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector (tapAction))
        addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    @objc private func tapAction() {
        delegate?.didTapAction()
    }
}
