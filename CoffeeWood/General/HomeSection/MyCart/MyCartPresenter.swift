import Foundation
import UIKit

class MyCartPresenter {
    
    weak var viewController: MyCartControllerInterface?
    
    private var cartPositions = [CartPosition]()
    private var user: DDUser? = nil
    
    deinit {
        print("MyCartPresenter is dead")
    }
    
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        DatabaseService.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(user))
            case .failure(let error):
                print(error.localizedDescription) 
            }
        }
    }
    
    private func getCartPositions() {
        if let user = self.user {
            getPositions(user.id)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getPositions(user.id)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getPositions(_ userID: String) {
        DatabaseService.shared.getCartPositions(from: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let positions):
                self.cartPositions = positions
                
                guard !positions.isEmpty else {
                    self.viewController?.setupEmptyCartView()
                    return
                }
                
                self.setImages(for: positions) { positions in
                    self.viewController?.presentCartPositions(positions)
                    self.cartPositions = positions
                }
            case .failure(let error):
                print(error.localizedDescription)
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
        DatabaseService.shared.deletePositionFromCart(userID: userID, positionID: positionID) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deletePositionFromCart(_ positionID: String) {
        if let user = self.user {
            removePosition(userID: user.id, positionID: positionID)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    removePosition(userID: user.id, positionID: positionID)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - MyCartControllerDelegate
extension MyCartPresenter: MyCartControllerDelegate {
    func willShowOrederConfirmationController() {
        if cartPositions.isEmpty {
            viewController?.popToHomeView()
        }
        viewController?.showOrderConfirmationController()
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
    
    func didFinishPresentCartPositions() {
        if cartPositions.isEmpty {
            viewController?.setupEmptyCartView()
        }
    }
}
