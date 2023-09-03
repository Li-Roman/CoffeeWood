import Foundation
import UIKit

class MyOrdersPresenter {
    
    weak var viewController: MyOrdersControllerInterface?
    
    private var user: DDUser? = nil
    
    // MARK: - Private Methods
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        DatabaseService.shared.getUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                completion(.success(user))
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func getOrders(for type: [OrderStatus]) {
        if let user = self.user {
            getAllUserOrders(for: type, userID: user.id)
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getAllUserOrders(for: type, userID: user.id)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getAllUserOrders(for type: [OrderStatus], userID: String) {
        DatabaseService.shared.getUserOrders(by: userID) { result in
            switch result {
            case .success(let orders):
                var resultOrders = [Order]()
                type.forEach { type in
                    resultOrders += orders.filter {$0.status == type}
                }
                for order in 0..<resultOrders.count {
                    DatabaseService.shared.getOrderPosistions(by: userID, orderID: resultOrders[order].id) { res in
                        switch res {
                        case .success(let positions):
                            resultOrders[order].cartPositions = positions
                            self.viewController?.presentOrders(resultOrders)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                self.viewController?.presentOrders(resultOrders)
            
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}

// MARK: - MyOrdersControllerDelegate
extension MyOrdersPresenter: MyOrdersControllerDelegate {
    func willShowOnGoingOrders() {
        getOrders(for: [.accepted, .processing, .completed])
    }
    
    func willShowHistoryOrders() {
        getOrders(for: [.closed])
    }
}
