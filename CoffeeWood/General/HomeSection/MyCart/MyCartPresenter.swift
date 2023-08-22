//
//  MyCartPresenter.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 17.08.2023.
//

import Foundation
import UIKit

class MyCartPresenter {
    
    weak var viewController: MyCartControllerInterface?
    
    private var cartPositions = [CartPosition]()
    private var user: DDUser? = nil
    
    deinit {
        print("MyCartPresenter is dead")
    }
    
    // TODO: - Здесь мы должны загрузить у юзера позиции, которые находятся в корзине. По сути мы должны распарсить пришедшие данные и отправить в виде массива во вью. После получения данных мы доолжны сохранить текущее состояние корзины в местную переменную cartPositions и при модификации позиций корзины во вью, модифицировать местную переменную.
    // TODO: - Если пользователь наживает кнопку чекаут, мы формируем заказ из нынешнего состояния корзины, и удаляем коллекию корзина из файрбейс.
    // TODO: - При попытке выхода из экрана корзины аналогично сохраняем состояни корзины в файрбейс
    
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
    
    private func getCartPositions() {
        if let user = self.user {
            print("enter in if getCartPositions")
            getPositions(user.id)
        } else {
            print("enter in else getCartPositions")
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getPositions(user.id)
                case .failure(let error):
                    print("\(error.localizedDescription) in getUser in MyCartPresenter")
                }
            }
        }
    }
    
    private func getPositions(_ userID: String) {
        print("enter in if getPositions")
        DatabaseService.shared.getCartPositions(from: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let positions):
                print("Success in MyCartPresenter")
                // TODO: - Здесь мы должны вызвать метод вью контроллера, чтобы обновить таблицу
                self.cartPositions = positions
//                self.viewController?.presentCartPositions(self.cartPositions)
                self.setImages(for: positions) { positions in
                    self.viewController?.presentCartPositions(positions)
                    self.cartPositions = positions
                }
            case .failure(let error):
                print("Error in MyCartPresenter - error = \(error.localizedDescription)")
            }
        }
    }
    
    private func setImages(for positions: [CartPosition], completion: @escaping ([CartPosition]) -> Void) {
        var positions = positions
        for i in 0..<positions.count {
            setImage(for: positions[i]) { position in
                positions[i] = position
                completion(positions)
            }
        }
    }
    
    private func setImage(for position: CartPosition, completion: @escaping (CartPosition) -> ()) {
        var position = position
        StorageService.shared.getImage(picture: position.productTitle) { image in
            position.productImage = image
            completion(position)
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
    
    private func configureOrder() {
        guard cartPositions.count > 0 else {
            // TODO: - Show empty cart alert
            return
        }
        
        if let user = self.user {
            let order = Order(userID: user.id,
                              cartPositions: cartPositions,
                              date: Date(),
                              address: user.address,
                              status: .onGoing)
            viewController?.showOrderConfirmationController(for: order)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.user = user
                    let order = Order(userID: user.id,
                                      cartPositions: self.cartPositions,
                                      date: Date(),
                                      address: user.address,
                                      status: .onGoing)
                    self.viewController?.showOrderConfirmationController(for: order)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension MyCartPresenter: MyCartControllerDelegate {
    func willShowOrederConfirmationController() {
//        viewController?.showOrderConfirmationController(for: <#T##Order#>)
        configureOrder()
    }
    
    func willShowCartPositions() {
        getCartPositions()
    }
    
    func deletePosition(at index: Int) {
        deletePositionFromCart(cartPositions[index].id)
        cartPositions.remove(at: index)
        viewController?.presentCartPositions(cartPositions)
    }
    
    func willPopToPrevController() {
        viewController?.showPrevController()
    }
    
//    func willSetOrder() {
//        // TODO: - Написать функцию, которая создает заказ в профиль пользователя и отдельно в базу
//        setOrder()
//    }
}
