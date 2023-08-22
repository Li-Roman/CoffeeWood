//
//  Position.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 07.08.2023.
//

import Foundation
import UIKit
import FirebaseFirestore

enum EspressoShot: String {
    case single = "single"
    case double = "double"
}

enum TemperatureType: String {
    case hot = "hot"
    case iced = "iced"
}

enum CupSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

enum IceAmount: String {
    case little = "little ice"
    case half = "half ice"
    case full = "full ice"
}

struct CartPosition {
    
    var id: String = UUID().uuidString
    var productTitle: String
    var productPrice: Double
    var productImage = UIImage(named: "default_coffee")!
    var count: Int
    var espressoCount: EspressoShot
    var temperatureType: TemperatureType
    var cupSize: CupSize
    var iceAmount: IceAmount
    
    var cost: Double {
        var cost: Double = productPrice
        cost *= CartPosition.switchCupSize(cupSize: self.cupSize)
        cost += self.espressoCount == .double ? 1 : 0
        cost *= Double(count)
        return cost
    }
    
    init(id: String = UUID().uuidString,
         productTitle: String,
         productPrice: Double,
         productImage: UIImage = UIImage(named: "default_coffee")!,
         count: Int,
         espressoCount: EspressoShot,
         temperatureType: TemperatureType,
         cupSize: CupSize,
         iceAmount: IceAmount) {
        
        self.id = id
        self.productTitle = productTitle
        self.productPrice = productPrice
        self.productImage = productImage
        self.count = count
        self.espressoCount = espressoCount
        self.temperatureType = temperatureType
        self.cupSize = cupSize
        self.iceAmount = iceAmount
    }
    
    init?(doc: QueryDocumentSnapshot) {
//        print("Enter in CartPosition init?, try to make position")
        let data = doc.data()
        
        guard let id = data["id"] as? String else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let count = data["count"] as? Int else { return nil }
        guard let espessoCount = data["espressoCount"] as? String else { return nil }
        guard let temperatureType = data["temperatureType"] as? String else { return nil }
        guard let cupSize = data["cupSize"] as? String else { return nil }
        guard let iceAmount = data["iceAmount"] as? String else { return nil }
        guard let cost = data["cost"] as? Double else { return nil }
        
//        print("id = \(id)\n title= \(title)\n count = \(count)\n espessoCount = \(espessoCount)\n temperatureType = \(temperatureType)\n cupSize = \(cupSize)\n iceAmount= \(iceAmount)\n cost = \(cost)")
        
        self.id = id
        self.productTitle = title
        self.count = count
        self.espressoCount = EspressoShot(rawValue: espessoCount) ?? .single
        self.temperatureType = TemperatureType(rawValue: temperatureType) ?? .hot
        self.cupSize = CupSize(rawValue: cupSize) ?? .small
        self.iceAmount = IceAmount(rawValue: iceAmount) ?? .half
        self.productPrice = CartPosition.countProductPice(cost,
                                                          EspressoShot(rawValue: espessoCount) ?? .single,
                                                          CupSize(rawValue: cupSize) ?? .small,
                                                          count: count)
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["title"] = productTitle
        repres["count"] = count
        repres["espressoCount"] = espressoCount.rawValue
        repres["temperatureType"] = temperatureType.rawValue
        repres["cupSize"] = cupSize.rawValue
        repres["iceAmount"] = iceAmount.rawValue
        repres["cost"] = cost
        return repres 
    }
    
    static func countProductPice(_ cost: Double, _ espressoCount: EspressoShot,
                                 _ cupSize: CupSize, count: Int) -> Double {
        var productPrice: Double = cost
        
        productPrice /= Double(count)
        productPrice -= espressoCount == .double ? 1 : 0
        productPrice /= CartPosition.switchCupSize(cupSize: cupSize)
        
        return productPrice
    }
    
    static func switchCupSize(cupSize: CupSize) -> Double {
        switch cupSize {
        case .small: return 1.0
        case .medium: return 1.5
        case .large: return 2.0
        }
    }
}


