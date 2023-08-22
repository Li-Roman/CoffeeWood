//
//  DetailPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 13.08.2023.
//

import Foundation
import UIKit

class DetailPresenter {
    
    weak var viewController: DetailControllerInterface?
    private let coffeeProduct: CoffeeProduct
    private var cartPosition: CartPosition!
    private var userID: String? = nil
    
    init(_ coffeeProduct: CoffeeProduct) {
        self.coffeeProduct = coffeeProduct
        cartPosition = CartPosition(productTitle: coffeeProduct.title,
                                    productPrice: coffeeProduct.price,
                                    count: 1,
                                    espressoCount: .single,
                                    temperatureType: .hot,
                                    cupSize: .small,
                                    iceAmount: .half)
    }
    
    // MARK: - Private Methods
    private func showAlert(_ alert: UIAlertController) {
        self.viewController?.showAlert(alert)
    }
    
    private func setPosition(to userID: String) {
        let positionToAdd = CartPosition(productTitle: cartPosition.productTitle,
                                         productPrice: cartPosition.productPrice,
                                         count: cartPosition.count,
                                         espressoCount: cartPosition.espressoCount,
                                         temperatureType: cartPosition.temperatureType,
                                         cupSize: cartPosition.cupSize,
                                         iceAmount: cartPosition.iceAmount)
        
        DatabaseService.shared.addCartPosition(to: userID, positions: positionToAdd) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert((self.configureAlertControlelr(title: "\(error.localizedDescription)")))
            }
        }
        getCartPositionsCount(animate: true)
    }
    
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        DatabaseService.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.userID = user.id
                completion(.success(user))
            case .failure(let error):
                print("\(error.localizedDescription) in getUser in DetailPresenter")
            }
        }
    }
    
    private func setPositionToCart() {
        if let userID = self.userID {
            setPosition(to: userID)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.setPosition(to: user.id)
                case .failure(let error):
                    self.showAlert((self.configureAlertControlelr(title: "\(error.localizedDescription)")))
                }
            }
        }
    }
    
    private func configureAlertControlelr(title: String) -> UIAlertController {
        print("Configure alert controller")
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
    
    private func getCartPositionsCount(animate: Bool) {
        if let userID = self.userID {
            getPositions(userID, animate: animate)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getPositions(user.id, animate: animate)
                case .failure(let error):
                    print("\(error.localizedDescription) in getUser in DetailPresenter")
                }
            }
        }
    }
    
    private func getPositions(_ userID: String, animate: Bool) {
        DatabaseService.shared.getCartPositions(from: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let positions):
                self.viewController?.updateCartCountLabel(withAnimate: animate, count: positions.count)
            case .failure(let error):
                print("Error in DetailPresenter - error = \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - DetailControllerDelegate
extension DetailPresenter: DetailControllerDelegate {
    func willShowCountLabel() {
        getCartPositionsCount(animate: false)
    }
    
    func willBackToPrevController() {
        viewController?.popToPrevController()
    }
    
    func didQuanityChange(for count: Int) {
        cartPosition.count = count
        viewController?.updateResulCostLabel(for: cartPosition.cost)
    }
    
    func didShotChange(for type: EspressoShot) {
        cartPosition.espressoCount = type
        viewController?.updateResulCostLabel(for: cartPosition.cost)
    }
    
    func didTemperatureTypeChange(for type: TemperatureType) {
        cartPosition.temperatureType = type
        viewController?.updateResulCostLabel(for: cartPosition.cost)
    }
    
    func didCupSizeChange(for type: CupSize) {
        cartPosition.cupSize = type
        viewController?.updateResulCostLabel(for: cartPosition.cost)
    }
    
    func didIceAmountChange(for type: IceAmount) {
        cartPosition.iceAmount = type
        viewController?.updateResulCostLabel(for: cartPosition.cost)
    }
    
    func willAddPositionToCart() {
        setPositionToCart()
    }
    
    func willShowMyCatrController() {
        viewController?.showMyCartController()
    }
}
