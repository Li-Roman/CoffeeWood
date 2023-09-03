import Foundation
import UIKit
import SnapKit

protocol OrderConfirmationControllerDelegate: AnyObject {
    var viewController: OrderConfirmationControllerInterface? { get set }
    func willShowTotoalCostSection()
    func willShowCoffeeHouseAddress()
    func willShowPickupTime()
    func willSetOrder()
    func willChangeAddress()
    func willChangePickupTime()
}

protocol OrderConfirmationControllerInterface: AnyObject {
    func showAlert(_ alertController: UIAlertController)
    func setTotalcostSectionWith(totalCost: Double, subtotalCost: Double, taxCost: Double)
    func setChosingAddress(address: String, openTodayText: String)
    func setChosingTime(time: String)
    func showPopUp(for conrtoller: UIViewController)
    func startAnimatePayButton()
    func stopAnimatePayButton(with result: CustomResultType, completion: @escaping () -> Void)
}

class OrderConfirmationController: UIViewController {
    
    var delegate: OrderConfirmationControllerDelegate?
    
    private var orderConfirmationView: OrderConfirmationView?
    
    init(delegate: OrderConfirmationControllerDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.willShowPickupTime()
    }
    
    // MARK: - Setup View
    private func setupView() {
        orderConfirmationView = OrderConfirmationView(delegate: self)
        delegate?.viewController = self
        
        view.addSubview(orderConfirmationView!)
        orderConfirmationView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - OrderConfirmationViewDelegate
extension OrderConfirmationController: OrderConfirmationViewDelegate {
    func willShowCoffeeHouseAddress() {
        delegate?.willShowCoffeeHouseAddress()
    }
    
    func willShowPickupTime() {
        delegate?.willShowPickupTime()
    }
    
    func didTappedEditAddress() {
        delegate?.willChangeAddress()
    }
    
    func didTappedEditPickupTime() {
        delegate?.willChangePickupTime()
    }
    
    func didTappedPayNowButton() {
        delegate?.willSetOrder()
    }
    
    func willShowTotalCostSection() {
        delegate?.willShowTotoalCostSection()
    }
}

// MARK: - OrderConfirmationControllerInterface
extension OrderConfirmationController: OrderConfirmationControllerInterface {
    func showAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func setTotalcostSectionWith(totalCost: Double, subtotalCost: Double, taxCost: Double) {
        orderConfirmationView?.setTotalcostSectionWith(totalCost: totalCost, subtotalCost: subtotalCost, taxCost: taxCost)
    }
    
    func setChosingAddress(address: String, openTodayText: String) {
        orderConfirmationView?.setChosingAddress(address: address,
                                                openTodayText: openTodayText)
    }
    
    func setChosingTime(time: String) {
        orderConfirmationView?.setChosingTime(time: time)
    }
    
    func showPopUp(for conrtoller: UIViewController) {
        DispatchQueue.main.async {
            let popUp = conrtoller
            popUp.modalPresentationStyle = .popover
            
            let popOverVC = popUp.popoverPresentationController
            popOverVC?.delegate = self
            if let view = self.orderConfirmationView?.getAddressSectionView() {
                popOverVC?.sourceView = view
                popOverVC?.sourceRect = CGRect(x: Int(view.bounds.midX ), y: Int(view.bounds.minY), width: 0, height: 0)
            }
            popUp.preferredContentSize = CGSize(width: screenSize.width - 60, height: 100)
            self.present(popUp, animated: true)
        }
    }
    
    func startAnimatePayButton() {
        orderConfirmationView?.startAnimatePayButton()
    }
    
    func stopAnimatePayButton(with result: CustomResultType, completion: @escaping () -> Void) {
        orderConfirmationView?.stopAnimateButton(with: result, completion: completion)
    }
}

extension OrderConfirmationController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
