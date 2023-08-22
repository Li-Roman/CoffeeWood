//
//  HomeViewPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 06.08.2023.
//

import Foundation
import UIKit

class HomePresenter {
    
    weak var viewController: HomeControllerInterface?
//    private var products: [CoffeeProduct] = []
//    private var cart = Cart()
    private var user: DDUser? = nil
    
    // MARK: - Private Methods
    
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        print("enter in getUser")
        DatabaseService.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(user))
            case .failure(let error):
                print("\(error.localizedDescription) in getUser in MyCartPresenter")
            }
        }
    }
    
    private func pushProfileController() {
        if let user = self.user {
            self.viewController?.pushProfileController(user: user)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.viewController?.pushProfileController(user: user)
                case .failure(let error):
                    self.viewController?.showAlert(self.setupAlertGetUserError(with: error))
                }
            }
        }
    }
    
    private func getCoffeeProducts() {
        print("enter in getCoffeeProducts")
        DatabaseService.shared.getAllCoffeeProducts { [weak self] result in
            switch result {
            case .success(let products):
                print(products)
                self?.setImages(for: products) { products in
                    self?.viewController?.presentCoffeeProducts(products: products)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setImages(for products: [CoffeeProduct], completion: @escaping ([CoffeeProduct]) -> Void) {
        var products = products
        for i in 0..<products.count {
            setImage(for: products[i]) { product in
                products[i] = product
                completion(products)
            }
        }
    }
    
    private func setImage(for product: CoffeeProduct, completion: @escaping (CoffeeProduct) -> ()) {
        var product = product
        StorageService.shared.getImage(picture: product.title) { image in
            product.image = image
            completion(product)
        }
    }
    
    private func setupAlertGetUserError(with error: Error) -> UIAlertController {
        let alertTitle = "Sorry, try again later"
        let alertMessage = "\(error.localizedDescription)"
        let okTitle = "Ok"
        return AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                     alertMessage,
                                                     okTitle,
                                                     style: .alert,
                                                     handler: nil)
    }
    
    private func showUsername() {
        getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.viewController?.presentUsername(user.name)
            case .failure(let error):
                print(error.localizedDescription)
                self.viewController?.presentUsername("User")
            }
        }
    }
    
    private func getCartPositionsCount() {
        if let userID = self.user?.id {
            getPositions(userID)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getPositions(user.id)
                case .failure(let error):
                    print("\(error.localizedDescription) in getUser in HomePresenter")
                }
            }
        }
    }
    
    private func getPositions(_ userID: String) {
        DatabaseService.shared.getCartPositions(from: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let positions):
                self.viewController?.updateCartCountLabel(isHidden: positions.count == 0, count: positions.count)
            case .failure(let error):
                print("Error in MyCartPresenter - error = \(error.localizedDescription)")
            }
        }
    }
}
    

// MARK: - HomeControllerDelegate
extension HomePresenter: HomeControllerDelegate {    
    func willShowCoffeeProducts() {
        print("willShowCoffeeProducts in presenter")
        getCoffeeProducts()
    }
    
    func willShowCartController() {
        print("willShowCartController in presenter")
        viewController?.pushCartController()
    }
    
    func willShowProfileController() {
        pushProfileController()
    }
    
    func willShowDetailController(for coffeeProduct: CoffeeProduct) {
        viewController?.pushDetailController(for: coffeeProduct)
    }
    
    func willShowUsername() {
        showUsername()
    }
    
    func willShowCountLabel() {
        getCartPositionsCount()
    }
}
