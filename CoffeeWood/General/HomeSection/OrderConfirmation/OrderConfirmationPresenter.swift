//
//  OrderConfirmationPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 20.08.2023.
//

import Foundation
import UIKit
 
class OrderConfirmationPresenter {
    
    weak var viewController: OrderConfirmationControllerInterface?
    private var user: DDUser? = nil
    private var order: Order?
    
    init(order: Order) {
        self.order = order
    }
    
    deinit {
        print("OrderConfirmationPresenter is dead")
    }
    
    // MARK: - Private Methods
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        DatabaseService.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(user))
            case .failure(let error):
                print("\(error.localizedDescription) in getUser in OrderConfirmationPresenter")
            }
        }
    }
    
    private func setOrder() {
        guard let order = self.order else {
            // TODO: - Show error alert
            return
        }
        
        if let user = self.user {
            setOrderInDB(to: user)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    setOrderInDB(to: user)
                case .failure(let error):
                    showErrorSetOrderAlert(error: error)
                }
            }
        }
    }
    
    private func setOrderInDB(to user: DDUser) {
        print("Enter in setOrderInDB")
        let dbOrder = Order(id: order!.id,
                            userID: order!.userID,
                            cartPositions: order!.cartPositions,
                            date: order!.date,
                            address: order!.address,
                            status: order!.status)
        
        DatabaseService.shared.addOrderToUser(userID: user.id, order: dbOrder) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorSetOrderAlert(error: error)
                return
            }
        }
        self.showSuccessAddingOrder()
        self.cleanUsersCart(userID: user.id)
    }
    
    private func cleanUsersCart(userID: String) {
        let positions = order!.cartPositions
        for position in 0..<positions.count {
            deletePositionFromCart(positions[position].id)
        }
    }
    
    private func deletePositionFromCart(_ positionID: String) {
        if let user = self.user {
            print("enter in if deletePositionFromCart")
            removePosition(userID: user.id, positionID: positionID)
        } else {
            print("enter in else deletePositionFromCart")
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    removePosition(userID: user.id, positionID: positionID)
                case .failure(let error):
                    print("\(error.localizedDescription) in getUser in MyCartPresenter")
                }
            }
        }
    }
    
    private func removePosition(userID: String, positionID: String) {
        print("enter in if removePosition in presenter")
        DatabaseService.shared.deletePositionFromCart(userID: userID, positionID: positionID) { error in
            if let error = error {
                print("Error in delete position from cart, error = \(error.localizedDescription)")
            }
        }
    }
    
    private func showErrorSetOrderAlert(error: Error) {
        let alertTitle = "Something goes wrong"
        let alertMessage = "\(error.localizedDescription)"
        let okTitle = "Ok"
        let alertController = AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                                    alertMessage,
                                                                    okTitle,
                                                                    style: .alert, handler: nil)
        self.viewController?.showAlert(alertController)
    }
    
    private func showEmptyCartAlert() {
        let alertTitle = "Your cart is empty"
        let alertMessage = "Add at least 1 position to continue"
        let okTitle = "Ok"
        let alertController = AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                                    alertMessage,
                                                                    okTitle,
                                                                    style: .alert, handler: nil)
        viewController?.showAlert(alertController)
    }
    
    private func showSuccessAddingOrder() {
        print("showSuccessAddingOrder ")
        
        let alertTitle = "Success"
        let alertMessage = "We have already started to place your order"
        let okTitle = "Ok"
        let alertController = AlertControllerMaker.makeDefaultAlert(alertTitle,
                                                                    alertMessage,
                                                                    okTitle,
                                                                    style: .alert) { action in
//            self.viewController?.showPrevController()
        }
        self.viewController?.showAlert(alertController)
    }
    
}

// MARK: - OrderConfirmationControllerDelegate
extension OrderConfirmationPresenter: OrderConfirmationControllerDelegate {
    func willSetOrder() {
        print("will set oreder in OrderConfirmationPresenter")
        setOrder()
    }
}
