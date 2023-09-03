import Foundation
import FirebaseFirestore

enum OrderStatus: String {
    case accepted = "Accepted"
    case processing = "Processing"
    case completed = "Completed"
    case closed = "Closed"
}

struct Order {
    
    var id: String = UUID().uuidString
    var userID: String
    var cartPositions = [CartPosition]()
    var date: Date
    var address: String
    var status: OrderStatus
    var pickupTime: String = ""
    
    var cost: Double {
        cartPositions.reduce(0) { $0 + $1.cost}
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userID"] = userID
        repres["date"] = Timestamp(date: date)
        repres["status"] = status.rawValue
        repres["address"] = address
        repres["cost"] = cost
        repres["pickupTime"] = pickupTime
        return repres
    }
    
    init(id: String = UUID().uuidString,
         userID: String,
         cartPositions: [CartPosition] = [CartPosition](),
         date: Date,
         address: String,
         pickupTime: String = "",
         status: OrderStatus) {
        self.id = id
        self.userID = userID
        self.cartPositions = cartPositions
        self.date = date
        self.address = address
        self.pickupTime = pickupTime
        self.status = status
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let userID = data["userID"] as? String else { return nil }
        guard let date = data["date"] as? Timestamp else { return nil }
        guard let status = data["status"] as? String else { return nil }
        guard let address = data["address"] as? String else { return nil }
        guard let pickupTime = data["pickupTime"] as? String else { return nil }
        
        self.id = id
        self.userID = userID
        self.date = date.dateValue()
        self.status = OrderStatus(rawValue: status) ?? OrderStatus.completed
        self.address = address
        self.pickupTime = pickupTime
    }
}
