//
//  DetailController.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 13.08.2023.
//

import Foundation
import UIKit
import SnapKit

protocol DetailControllerDelegate: AnyObject {
    func didQuanityChange(for count: Int)
    func didShotChange(for type: EspressoShot)
    func didTemperatureTypeChange(for type: TemperatureType)
    func didCupSizeChange(for type: CupSize)
    func didIceAmountChange(for type: IceAmount)
    func willAddPositionToCart()
    func willShowMyCatrController()
    func willBackToPrevController()
    func willShowCountLabel()
}

protocol DetailControllerInterface: AnyObject {
    func updateResulCostLabel(for price: Double)
    func showAlert(_ alert: UIAlertController)
    func showMyCartController()
    func popToPrevController()
    func updateCartCountLabel(withAnimate: Bool, count: Int)
}

class DetailController: UIViewController {
    
    var delegate: DetailControllerDelegate?
    
    private var detailView: DetailView!
    
    private let coffeeProduct: CoffeeProduct
    
    init(_ coffeeProduct: CoffeeProduct) {
        self.coffeeProduct = coffeeProduct
        super.init(nibName: nil, bundle: nil)
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
        delegate?.willShowCountLabel()
    }
    
    deinit {
        print("DetailController is dead")
    }
    
    // MARK: - Private Methods
    private func setupView() {
        detailView = DetailView(coffeeProduct: coffeeProduct)
        detailView.delegate = self
        
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        setupNavController()
    }
    
//    private func setupNavController() {
//        self.title = "Details"
//        navigationController?.navigationBar.isHidden = true
//
//        let arrowImage = UIImage(systemName: "arrow.left")!
//        let backButton = UIBarButtonItem(image: arrowImage, style: .plain, target: self, action: #selector(leftBarButtonAction(sender:)))
//        navigationItem.leftBarButtonItem = backButton
//
//        let cartImage = Resources.Images.HomePage.cart
//        let cartButton = UIButton()
////        cartButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
//        cartButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
//        cartButton.setImage(cartImage, for: .normal)
//        cartButton.addTarget(self, action: #selector(cartBarButtonAction(sender:)), for: .touchUpInside)
//        cartButton.imageView?.contentMode = .scaleAspectFit
//
//        let rightBarButton = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 22)))
//        rightBarButton.customView?.addSubview(cartButton)
//        rightBarButton.customView?.frame = cartButton.frame
//
//        navigationItem.rightBarButtonItem = rightBarButton
//    }
}

//// MARK: - Actions
//extension DetailController {
//    @objc private func leftBarButtonAction(sender: UIBarButtonItem) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc private func cartBarButtonAction(sender: UIBarButtonItem) {
//        delegate?.willShowMyCatrController()
//    }
//}

// MARK: - DetailViewDelegate
extension DetailController: DetailViewDelegate {
    func willShowCartCountLabel() {
        delegate?.willShowCountLabel()
    }
    
    func didQuanityChange(for count: Int) {
        delegate?.didQuanityChange(for: count)
    }
    
    func didShotChange(for type: EspressoShot) {
        delegate?.didShotChange(for: type)
    }
    
    func didTemperatureTypeChange(for type: TemperatureType) {
        delegate?.didTemperatureTypeChange(for: type)
    }
    
    func didCupSizeChange(for type: CupSize) {
        delegate?.didCupSizeChange(for: type)
    }
    
    func didIceAmountChange(for type: IceAmount) {
        delegate?.didIceAmountChange(for: type)
    }
    
    func didTappedCheckoutButton() {
        delegate?.willAddPositionToCart()
    }
    
    func didTappedCartButton() {
        delegate?.willShowMyCatrController()
    }
    
    func didTappedBackArrowButton() {
        delegate?.willBackToPrevController()
    }
}

// MARK: - DetailControllerInterface
extension DetailController: DetailControllerInterface {
    func updateCartCountLabel(withAnimate: Bool, count: Int) {
        detailView.updateCartLabelCount(withAnimate: withAnimate, count: count)
    }
    
    func updateResulCostLabel(for price: Double) {
        detailView.updateResulCostLabel(for: price)
    }
    
    func showAlert(_ alert: UIAlertController) {
        print("Show alert in controller")
        present(alert, animated: true)
    }
    
    func showMyCartController() {
        let myCartController = MyCartModuleAssembly.configureMoule()
        navigationController?.pushViewController(myCartController, animated: true)
    }
    
    func popToPrevController() {
        navigationController?.popViewController(animated: true)
    }
}
