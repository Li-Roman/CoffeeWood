import Foundation
import UIKit
import SnapKit

protocol TimePickerControllerDelegate: AnyObject {
    func didSelect(time: Date)
}

class TimePickerController: UIViewController {
    
    weak var delegate: TimePickerControllerDelegate?
    
    private let pickerView = UIDatePicker()
    private let minTime: Date
    private let maxTime: Date
    private let showTime: Date
    
    init(delegate: TimePickerControllerDelegate, minTime: Date, maxTime: Date, showTime: Date) {
        self.delegate = delegate
        self.minTime = minTime
        self.maxTime = maxTime
        self.showTime = showTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Setup View
extension TimePickerController {
    private func setupView() {
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.datePickerMode = .time
        pickerView.minuteInterval = 10
        pickerView.minimumDate = minTime
        pickerView.maximumDate = maxTime
        pickerView.date = showTime
        pickerView.addTarget(self, action: #selector(datePickerAction(sender:)), for: .valueChanged)
    }
}

// MARK: - Actions
extension TimePickerController {
    @objc private func datePickerAction(sender: UIDatePicker) {
        print("datePickerAction, sender date: hour = \(sender.date.get(.hour)), minute = \(sender.date.get(.minute))")
        delegate?.didSelect(time: sender.date)
    }
}
