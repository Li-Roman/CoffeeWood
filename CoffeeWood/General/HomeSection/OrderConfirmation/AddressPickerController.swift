import Foundation
import UIKit
import SnapKit

protocol AddressPickerControllerDelegate: AnyObject {
    func didSelect(coffeeHouse: CoffeeHouseAnnotation)
}

class AddressPickerController: UIViewController {
    
    weak var delegate: AddressPickerControllerDelegate?
    
    private var dataSource: [CoffeeHouseAnnotation]
    
    private let pickerView = UIPickerView()
    
    init(delegate: AddressPickerControllerDelegate, dataSource: [CoffeeHouseAnnotation]) {
        self.delegate = delegate
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup View
extension AddressPickerController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        setupPickerView()
    }
    
    private func setupPickerView() {
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

// MARK: - UIPickerViewDelegate
extension AddressPickerController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].address
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelect(coffeeHouse: dataSource[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel: UILabel
        
        if let label = view as? UILabel {
            pickerLabel = label
        } else {
            pickerLabel = UILabel()
            pickerLabel.font = Resources.Font.OrderConfirmation.paymenstMainLabel
            pickerLabel.textAlignment = .center
            pickerLabel.textColor = AppColors.Labels.darkBlue
            pickerLabel.text = dataSource[row].address
        }
        
        return pickerLabel
    }
}

// MARK: - UIPickerViewDataSource
extension AddressPickerController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSource.count
    }
}
