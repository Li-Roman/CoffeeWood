import Foundation

struct DDUser: Identifiable {
    
    var id: String
    var name: String
    var email: String
    var mobileNumber: String
    var address: String
    
    var representation: [String: Any] {
        
        var representation = [String: Any]()
        
        representation["id"] = id
        representation["name"] = name
        representation["email"] = email
        representation["mobileNumber"] = mobileNumber
        representation["address"] = address
        
        return representation
    }
}
