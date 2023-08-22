//
//  StorageService.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 07.08.2023.
//

import Foundation
import Firebase
import FirebaseStorage

final class StorageService {
    
    static let shared = StorageService()
    private let storage = Storage.storage()
    
    private var coffeeProductsRef: StorageReference {
        storage.reference().child("CoffeeProducts")
    }
    
    private init() { }
    
    func getImage(picture name: String, completion: @escaping (UIImage) -> Void) {
        var image = UIImage(named: "default_coffee")!
        print("print name \(name) in getImage")
        
        let fileRef = coffeeProductsRef.child(name + ".png")
        fileRef.getData(maxSize: 1024*1024) { data, error in
            guard let data = data, error == nil else {
                print("Put default image, sorry")
                completion(image)
                return
            }
            image = UIImage(data: data)!
            completion(image)
        }
    }
}
