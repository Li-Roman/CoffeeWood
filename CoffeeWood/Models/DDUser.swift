//
//  DDUser.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 23.07.2023.
//

import Foundation

struct DDUser: Identifiable {
    
    var id: String
    var name: String
    var email: String
    var mobileNumber: String
    var address: String
//    var ordersID: String = UUID().uuidString
    
    var representation: [String: Any] {
        
        var representation = [String: Any]()
        
        representation["id"] = id
        representation["name"] = name
        representation["email"] = email
        representation["mobileNumber"] = mobileNumber
        representation["address"] = address
//        representation["ordersID"] = ordersID
        
        return representation
    }
}
