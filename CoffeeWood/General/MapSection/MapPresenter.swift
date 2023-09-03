import UIKit
import CoreLocation
import MapKit

class MapPresenter: NSObject {
    
    weak var viewConrtoller: MapControllerInterface?
    weak var coffeeHouseController: CoffeeHouseControllerInterface?
    
    private let locationManager = CLLocationManager()
    private let regionInMetersForUser: Double = 7000
    private let regionInMetersForCoffeeHouse: Double = 5000
    
    private var user: DDUser? = nil
    private var coffeeHouses: [CoffeeHouseAnnotation]? = nil
    private var activeOrders: [Order]? = nil
    private var lastUserOrder: Order? = nil
    private var selectedAnnotation: CoffeeHouseAnnotation? = nil
    
    // MARK: - Private Methods
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationServicesEnable() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            viewConrtoller?.showAlert(setupLocationAlertController("У вас выключены служба геолокации", "Вкючить?", URL(string: "App-Prefs:root=LOCATION_SERVICES")))
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .denied:
            viewConrtoller?.showAlert(setupLocationAlertController("Вы запретили использование метоположения", "Хотите изменить", URL(string: UIApplication.openSettingsURLString)))
            break
        case .authorizedAlways:
            // TODO: show alert why they cant see their location
            break
        case .authorizedWhenInUse:
            setMapValues()
            break
        @unknown default:
            break
        }
    }
    
    private func setMapValues() {
        viewConrtoller?.turnOnUserLocation()
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMetersForUser,
                                            longitudinalMeters: regionInMetersForUser)
            viewConrtoller?.centerInRegion(region)
        }
    }

    private func setupLocationAlertController(_ title: String, _ message: String?, _ url: URL?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Включить", style: .default) { action in
            if let url = url {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        return alert
    }
}

// MARK: - Database Methods
extension MapPresenter {
    private func getUser(completion: @escaping (Result<DDUser, Error>) -> Void) {
        checkLocationServicesEnable()
        DatabaseService.shared.getUser { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getActiveOrders(completion: @escaping (Result<[Order], Error>) -> Void) {
        if let user = self.user {
            getFilteredOrders(for: [.accepted, .processing, .completed], userID: user.id) { result in
                switch result {
                case .success(let orders):
                    self.activeOrders = orders
                    completion(.success(orders))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            getUser { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.getFilteredOrders(for: [.accepted, .processing, .completed], userID: user.id) { result in
                        switch result {
                        case .success(let orders):
                            self.activeOrders = orders
                            completion(.success(orders))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func getFilteredOrders(for type: [OrderStatus], userID: String,
                                   completion: @escaping (Result<[Order], Error>) -> Void) {
        DatabaseService.shared.getUserOrders(by: userID) { result in
            switch result {
            case .success(let orders):
                var resultOrders = [Order]()
                
                type.forEach { type in
                    resultOrders += orders.filter {$0.status == type}
                }
                completion(.success(resultOrders))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func findNewestOrder(in activeOrders: [Order]?) -> Order? {
        guard let activeOrders = activeOrders, activeOrders.count > 0 else { return nil }
        var resultOrder = activeOrders[0]
        for order in activeOrders {
            if order.date < resultOrder.date {
                resultOrder = order
            }
        }
        self.lastUserOrder = resultOrder
        return resultOrder
    }
    
    private func getCoffeeHouses(completion: @escaping (Result<[CoffeeHouseAnnotation], Error>) -> Void) {
        DatabaseService.shared.getAllCoffeeHouses { result in
            switch result {
            case .success(let coffeeHouses):
                completion(.success(coffeeHouses))
                self.coffeeHouses = coffeeHouses
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func configureAnnotations(with orders: [Order], completion: @escaping (Result<[CoffeeHouseAnnotation], Error>) -> Void) {
        getCoffeeHouses { result in
            switch result {
            case .success(let coffeeHouses):
                let annotations: [CoffeeHouseAnnotation] = coffeeHouses
                for order in orders {
                    for i in 0..<coffeeHouses.count {
                        if order.address == coffeeHouses[i].address {
                            annotations[i].isActiveOrder = true
                        }
                    }
                }
                
                completion(.success(annotations))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func cofigureMapView() {
        getActiveOrders { [weak self] result in
            switch result {
            case .success(let orders):
                self?.configureAnnotations(with: orders) { result in
                    switch result {
                    case .success(let annotations):
                        self?.coffeeHouses = annotations
                        self?.viewConrtoller?.showCoffeeHouses(annotations)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showCoffeeHouseVC(with activeOrder: Order?) {
        let coffeeHouseVC = CoffeeHouseController(delegate: self, activeOrder: activeOrder)
        if let sheet = coffeeHouseVC.sheetPresentationController {
            sheet.preferredCornerRadius = 30
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom(resolver: { context in
                        280
                    })
                ]
                sheet.largestUndimmedDetentIdentifier = sheet.detents[0].identifier
            } else {
                sheet.detents = [.medium()]
                sheet.largestUndimmedDetentIdentifier = .medium
            }
        }
        viewConrtoller?.presentVC(viewController: coffeeHouseVC)
        viewConrtoller?.replaceCurrentLocationButtonUp(to: .up)
    }
}

extension MapPresenter: MapControllerDelegate {
    func viewDidLoad() {
        checkLocationServicesEnable()
        
        guard self.user == nil else { return }
        getUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: - Make alert
            }
        }
    }
    
    func viewWillAppear() {
        cofigureMapView()
    }
    
    func didFinishObtainCoffeeHouses() {
        guard let activeOrders = self.activeOrders, !activeOrders.isEmpty else {
            return
        }
        
        guard let coffeeHouses = coffeeHouses else {
            return
        }
        
        let lastOrder = findNewestOrder(in: activeOrders)!
        let lastOrderCoffeeHouse = coffeeHouses.first { lastOrder.address == $0.address }
        
        guard let coffeeHouse = lastOrderCoffeeHouse else {
            return
        }
        
        viewConrtoller?.selectAnnotation(annotation: coffeeHouse)
    }
    
    func willCenterUserLocation() {
        checkLocationServicesEnable()
    }
    
    func didSelectAnnotation(annotation: CoffeeHouseAnnotation) {
        if let activeOrders = self.activeOrders {
            let filteredOrders = activeOrders.filter { $0.address == annotation.address }
            let newestOrderInCoffeeHouse = findNewestOrder(in: filteredOrders)
            
            if let coffeeHouse = self.coffeeHouseController {
                coffeeHouse.setupView(with: annotation, activeOrder: newestOrderInCoffeeHouse)
            } else {
                showCoffeeHouseVC(with: newestOrderInCoffeeHouse)
            }
        } else {
            if let coffeeHouse = self.coffeeHouseController {
                coffeeHouse.setupView(with: annotation, activeOrder: nil)
            } else {
                showCoffeeHouseVC(with: nil)
            }
        }
    }
    
    func didDeselectAnnotation(annotation: CoffeeHouseAnnotation) {
        print("didDeselectAnnotation")
    }
}

// MARK: - CLLocationManagerDelegate
extension MapPresenter: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MapPresenter: CoffeeHouseControllerDelegate {
    func willDeinitCoffeeHouseController() {
        viewConrtoller?.replaceCurrentLocationButtonUp(to: .down)
        viewConrtoller?.deselectAnnotation(annotation: selectedAnnotation)
        selectedAnnotation = nil
    }
}
