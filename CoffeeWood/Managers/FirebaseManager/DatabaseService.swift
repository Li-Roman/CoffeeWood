//
//  DatabaseService.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 23.07.2023.
//

import Foundation
import FirebaseFirestore

final class DatabaseService {
    
    static let shared = DatabaseService()
    private let database = Firestore.firestore()
    
    private var userRef: CollectionReference {
        database.collection("users")
    }
    
    private var coffeeProductRef: CollectionReference {
        database.collection("coffeeProducts")
    }
    
    private var orderRef: CollectionReference {
        database.collection("orders")
    }
    
    private init() { }
    
    /// This Method allows set current users propeties
    func setUser(user: DDUser, completion: @escaping (Result<DDUser, Error>) -> Void) {
        userRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    /// This Method returns current user propeties
    func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        guard let uid = AuthService.shared.currentUser?.uid else { return }
        
        userRef.document(uid).getDocument { docSnapshot, error in
            guard let data = docSnapshot?.data() else { return }
            guard let name = data["name"] as? String,
                  let id = data["id"] as? String,
                  let email = data["email"] as? String,
                  let mobileNumber = data["mobileNumber"] as? String,
                  let address = data["address"] as? String else { return }
            
            let user = DDUser(id: id, name: name, email: email, mobileNumber: mobileNumber, address: address)
            completion(.success(user))
        }
    }
    
    func getUserOrders(by userID: String, completion: @escaping (Result<[Order], Error>) -> Void) {
        print("Enter in getUser Orders in get orders DB")
        let ordersRef = userRef.document(userID).collection("orders")
        
        ordersRef.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var orders = [Order]()
            print("Enter in for-in loop in DB, data.documents count = \(data.documents.count)")
            for document in data.documents {
                if let order = Order(doc: document) {
                    orders.append(order)
                }
            }
            print("Orders count = \(orders.count)")
            completion(.success(orders))
        }
    }
    
    func getOrderPosistions(by userID: String, orderID: String, completion: @escaping (Result<[CartPosition], Error>) -> Void) {
        print("Enter in getUser Orders in get positions DB")
        let ref = userRef.document(userID).collection("orders").document(orderID).collection("positions")
        ref.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil  else {
                completion(.failure(error!))
                return
            }
            
            var positions = [CartPosition]()
            print("Enter in for-in loop in DB, data.documents count = \(data.documents.count)")
            for document in data.documents {
                if let position = CartPosition(doc: document) {
                    positions.append(position)
                }
            }
            print("Positions count = \(positions.count)")
            completion(.success(positions))
        }
    }
    
//    // Функция, которая создает заказ вне юзера, просто в отдельную коллекцию orders
//    func setOrder(order: Order, completion: @escaping (Result<Order, Error>) -> Void) {
//        orderRef.document(order.id).setData(order.representation) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                self.setPositions(to: order.id, positions: order.cartPositions) { result in
//                    switch result {
//                    case .success(let positions):
//                        print(positions.count)
//                        completion(.success(order))
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
//    }
    
//    // Вспомогательная функция, которая в документе заказа создает коллецию positions и сохраняет каждую отдельную позицию
//    func setPositions(to orderID: String,
//                     positions: [CartPosition],
//                     completion: @escaping (Result<[CartPosition], Error>) -> Void) {
//        print("Enter in setPositions")
//        let positionRef = orderRef.document(orderID).collection("positions")
//
//        positions.forEach { position in
//            positionRef.document(position.id).setData(position.representation)
//        }
//        completion(.success(positions))
//    }
    
    func setPositionsToUserOrder(userID: String,
                                 to orderID: String,
                                 positions: [CartPosition],
                                 completion: @escaping (Result<[CartPosition], Error>) -> Void) {
        let positionRef = userRef.document(userID).collection("orders").document(orderID).collection("positions")
        
        positions.forEach { position in
            positionRef.document(position.id).setData(position.representation)
        }
        completion(.success(positions))
    }
    
    // Функция, которая добавляет позицию в коллекцию cart
    func addCartPosition(to userID: String,
                         positions: CartPosition,
                         completion: @escaping (Error?) -> Void) {
        
        let cartRef = userRef.document(userID).collection("cart")
        cartRef.document(positions.id).setData(positions.representation) { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
    // Функция, которая добавляет заказ к колекции ордерс
    func addOrderToUser(userID: String, order: Order, completion: @escaping (Error?) -> Void) {
        let userOrdersRef = userRef.document(userID).collection("orders")
        userOrdersRef.document(order.id).setData(order.representation) { error in
            guard error == nil else {
                completion(error)
                return
            }
            self.setPositionsToUserOrder(userID: userID, to: order.id, positions: order.cartPositions) { result in
                switch result {
                case .success(let positions):
                    print("positions count = \(positions.count)")
                case .failure(let error):
                    completion(error)
                }
                print("Success in add order to user")
            }
        }
    }
    
    // Функция, которая получает все позиции по текущему состоянию корзины
    func getCartPositions(from userID: String, completion: @escaping (Result<[CartPosition], Error>) -> Void) {
        let cartRef = userRef.document(userID).collection("cart")
        
        cartRef.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil else {
                print("Some error in guard in get cart positions")
                completion(.failure(error!))
                return
            }
            
            var cartPositions = [CartPosition]()
            for document in data.documents {
                
                if let position = CartPosition(doc: document) {
                    cartPositions.append(position)
                }
//                if let id = document["id"] as? String,
//                   let title = document["title"] as? String,
//                   let count = document["count"] as? Int,
//                   let cost = document["cost"] as? Double,
//                   let espressoCount = document["espressoCount"] as? String,
//                   let temperatureType = document["temperatureType"] as? String,
//                   let cupSize = document["cupSize"] as? String,
//                   let iceAmount = document["iceAmount"] as? String {
//                    cartPositions.append(.init(doc: document)
//
//                    print("products count = \(cartPositions.count)")
//                    print("no errors after check \(id)")
//
//                } else {
//                    print("some error in if")
//                }
            }
            print("success in DatabaseService")
            completion(.success(cartPositions))
        }
    }
    
    // Удаляет позицию из корзины юзера
    func deletePositionFromCart(userID: String, positionID: String, completion: @escaping (Error?) -> Void) {
        print("enter in if removePosition in Database")
        userRef.document(userID).collection("cart").document(positionID).delete { error in
            if let error = error {
                completion(error)
            }
        }
    }

    /// This Method returns an array of all coffee products from Firebase Database
    func getAllCoffeeProducts(completion: @escaping (Result<[CoffeeProduct], Error>) -> Void) {
        print("enter in getAllCoffeeProducts in DatabaseService")
        var products = [CoffeeProduct]()
        coffeeProductRef.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil else {
                completion(.failure(error!))
                print("failure in DatabaseService")
                return
            }
            print("no errors")
            print("data count = \(data.documents.count)")
            
            for document in data.documents {
                if let id           = document["id"]            as? String,
                   let title        = document["title"]         as? String,
                   let price        = document["price"]         as? Double,
                   let description  = document["description"]   as? String {
                    
                    products.append(.init(id: id,
                                          title: title,
                                          price: Double(price),
                                          description: description))
                    print("products count = \(products.count)")
                    
                    print("no errors after check \(title)")
                    
                } else {
                    print("some error in if")
                }
            }
            print("success in DatabaseService")
            completion(.success(products))
        }
        print("finish in DatabaseService")
        completion(.success(products))
    }
}
