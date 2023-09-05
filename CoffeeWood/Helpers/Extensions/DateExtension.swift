import Foundation

extension Date {
    func makeMeAppDateStyle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM | HH:MM"
        return dateFormatter.string(from: self)
    }
    
    func makeMeOnlyTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: self)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

