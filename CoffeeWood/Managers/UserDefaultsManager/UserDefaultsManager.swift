//
//  UserDefaultsManager.swift
//  CoffeeWood
//
//  Created by Роман Хилюк on 03.08.2023.
//

import Foundation

public enum UserDefaultsKeys: String {
    case emailTextFieldText
    case passwordTextFieldText
    case mobileNumberTextFieldText
    case usernameTextFieldText
}

// MARK: - CRUD = create, read, update, delete
protocol StorageManagerProtocol {
    func set(_ object: Any?, forkey key: UserDefaultsKeys)
    func set<T: Encodable> (object: T?, forKey key: UserDefaultsKeys)
    
    func int(forKey key: UserDefaultsKeys) -> Int?
    func string(forKey key: UserDefaultsKeys) -> String?
    func dict(forKey key: UserDefaultsKeys) -> [String: Any]?
    func date(forKey key: UserDefaultsKeys) -> Date?
    func bool(forKey key: UserDefaultsKeys) -> Bool?
    func data(forKey key: UserDefaultsKeys) -> Data?
    func codableData<T: Decodable> (forkey key: UserDefaultsKeys) -> T?
    func remove(forKey key: UserDefaultsKeys)
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: Private Methods
    private func store(_ object: Any?, key: String) {
        userDefaults.set(object, forKey: key)
    }
    
    private func restore(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}

// MARK: - StorageManagerProtocol
extension UserDefaultsManager: StorageManagerProtocol {
    // MARK: - Create/Upgrade Methods
    /// Метод установления любого объекта
    func set(_ object: Any?, forkey key: UserDefaultsKeys) {
        store(object, key: key.rawValue)
    }
    
    /// Метод установления кастомных структур
    func set<T: Encodable>(object: T?, forKey key: UserDefaultsKeys) {
        let jsonData = try? JSONEncoder().encode(object)
        store(jsonData, key: key.rawValue)
    }
    
    // MARK: - Read Methods
    func int(forKey key: UserDefaultsKeys) -> Int? {
        restore(forKey: key.rawValue) as? Int
    }
    
    func string(forKey key: UserDefaultsKeys) -> String? {
        restore(forKey: key.rawValue) as? String
    }
    
    func dict(forKey key: UserDefaultsKeys) -> [String : Any]? {
        restore(forKey: key.rawValue) as? [String : Any]
    }
    
    func date(forKey key: UserDefaultsKeys) -> Date? {
        restore(forKey: key.rawValue) as? Date
    }
    
    func bool(forKey key: UserDefaultsKeys) -> Bool? {
        restore(forKey: key.rawValue) as? Bool
    }
    
    func data(forKey key: UserDefaultsKeys) -> Data? {
        restore(forKey: key.rawValue) as? Data
    }
    
    func codableData<T: Decodable>(forkey key: UserDefaultsKeys) -> T? {
        guard let data = restore(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Delete Methods
    func remove(forKey key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
