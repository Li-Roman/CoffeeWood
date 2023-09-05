import Foundation
import MapKit
import FirebaseFirestore
import Contacts

class CoffeeHouseAnnotation: NSObject, MKAnnotation {
    
    var id: String
    var title: String?
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var phoneNumber: String
    var startWorkingHour: Double
    var endWorkingHour: Double
    var orders: [Order] = []
    var isActiveOrder = false
    
    var subtitle: String? {
        return address
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data["id"] as? String else {print("error in id"); return nil }
        guard let title = data["title"] as? String else {print("error in title"); return nil }
        guard let address = data["address"] as? String else {print("error in address");  return nil }
        guard let latitude = data["latitude"] as? CLLocationDegrees else {print("error in latitude");  return nil }
        guard let longitude = data["longitude"] as? CLLocationDegrees else {print("error in longitude");  return nil }
        guard let phoneNumber = data["phoneNumber"] as? String else {print("error in phoneNumber");  return nil }
        guard let startWorkingHour = data["startWorkingHour"] as? Double else {print("error in startWorkingHour");  return nil }
        guard let endWorkingHour = data["endWorkingHour"] as? Double else {print("error in endWorkingHour");  return nil }
        
        self.id = id
        self.title = title
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.phoneNumber = phoneNumber
        self.startWorkingHour = startWorkingHour
        self.endWorkingHour = endWorkingHour
    }
}
