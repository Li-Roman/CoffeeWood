import Foundation
import UIKit

struct CoffeeProduct: Identifiable {
    
    var id: String
    var title: String
    var image = UIImage(named: "default_coffee")!
    var price: Double
    var description: String
    
    var representation: [String: Any] {
        
        var representation = [String: Any]()
        
        representation["id"] = id
        representation["title"] = title
        representation["price"] = price
        representation["description"] = description
        
        return representation
    }
}

