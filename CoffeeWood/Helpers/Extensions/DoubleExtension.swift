import Foundation

extension Double {
    func makeMePrice() -> String {
        let decimalAmount = Decimal(self)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.usesGroupingSeparator = true
        
        let doubleValue = decimalAmount.doubleValue
        if let result = formatter.string(from: doubleValue as NSNumber) {
            return result
        }
        return ""
    }
}

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber (decimal:self) .doubleValue
    }
}

