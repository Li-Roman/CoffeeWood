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
    
    private var coffeeHouseRef: CollectionReference {
        database.collection("coffeeHouse")
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
        let ordersRef = userRef.document(userID).collection("orders")
        
        ordersRef.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var orders = [Order]()
            for document in data.documents {
                if let order = Order(doc: document) {
                    orders.append(order)
                }
            }
            completion(.success(orders))
        }
    }
    
    func getOrderPosistions(by userID: String, orderID: String, completion: @escaping (Result<[CartPosition], Error>) -> Void) {
        
        let ref = userRef.document(userID).collection("orders").document(orderID).collection("positions")
        ref.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil  else {
                completion(.failure(error!))
                return
            }
            
            var positions = [CartPosition]()
            
            for document in data.documents {
                if let position = CartPosition(doc: document) {
                    positions.append(position)
                }
            }
            completion(.success(positions))
        }
    }
    
    func getAllCoffeeHouses(completion: @escaping (Result<[CoffeeHouseAnnotation], Error>) -> Void) {

        coffeeHouseRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard let data = querySnapshot else {
                return
            }
            
            var coffeeHouses = [CoffeeHouseAnnotation]()
            for doc in data.documents {
                if let coffeeHouse = CoffeeHouseAnnotation(doc: doc) {
                    coffeeHouses.append(coffeeHouse)
                }
            }
            completion(.success(coffeeHouses))
        }
    }
    
    func setOrderToCoffeeHouse(id: String, order: Order,
                               completion: @escaping (Error?) -> Void) {
        
        let coffeeHouseRef = coffeeHouseRef.document(id).collection("orders").document(order.id)
        coffeeHouseRef.setData(order.representation) { error in
            if let error = error {
                completion(error)
            } else {
                order.cartPositions.forEach { position in
                    self.setPositionToCoffeeHouseOrder(coffeeHouseID: id,
                                                       orderID: order.id,
                                                       position: position) { error in
                        if let error = error {
                            completion(error)
                        }
                    }
                }
            }
        }
    }
    
    func setPositionToCoffeeHouseOrder(coffeeHouseID: String, orderID: String, position: CartPosition, completion: @escaping (Error?) -> Void ) {
        let positionsRef = coffeeHouseRef.document(coffeeHouseID).collection("orders").document(orderID).collection("positions").document(position.id)
        positionsRef.setData(position.representation) { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
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
    func serCartPosition(to userID: String,
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
    func setOrderToUser(userID: String, order: Order, completion: @escaping (Error?) -> Void) {
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
            }
        }
    }
    
    // Функция, которая получает все позиции по текущему состоянию корзины
    func getCartPositions(from userID: String, completion: @escaping (Result<[CartPosition], Error>) -> Void) {
        let cartRef = userRef.document(userID).collection("cart")
        
        cartRef.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var cartPositions = [CartPosition]()
            for document in data.documents {
                
                if let position = CartPosition(doc: document) {
                    cartPositions.append(position)
                }
            }
            completion(.success(cartPositions))
        }
    }
    
    // Удаляет позицию из корзины юзера
    func deletePositionFromCart(userID: String, positionID: String, completion: @escaping (Error?) -> Void) {
        userRef.document(userID).collection("cart").document(positionID).delete { error in
            if let error = error {
                completion(error)
            }
        }
    }

    /// This Method returns an array of all coffee products from Firebase Database
    func getAllCoffeeProducts(completion: @escaping (Result<[CoffeeProduct], Error>) -> Void) {
        var products = [CoffeeProduct]()
        coffeeProductRef.getDocuments { querySnapshot, error in
            guard let data = querySnapshot, error == nil else {
                completion(.failure(error!))
                return
            }
            
            for document in data.documents {
                if let id           = document["id"]            as? String,
                   let title        = document["title"]         as? String,
                   let price        = document["price"]         as? Double,
                   let description  = document["description"]   as? String {
                    
                    products.append(.init(id: id,
                                          title: title,
                                          price: Double(price),
                                          description: description))
                }
            }
            completion(.success(products))
        }
        completion(.success(products))
    }
}
