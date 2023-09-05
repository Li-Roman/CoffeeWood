////
////  MapTestViewController.swift
////  CoffeeWood
////
////  Created by Роман Хилюк on 24.08.2023.
////
//
//import UIKit
//import MapKit
//import SnapKit
//import CoreLocation
//
//class MapTestViewController: UIViewController {
//
//
//    private let mapView = MKMapView()
//
//    private var locationManager = CLLocationManager()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
////        locationManager.startUpdatingLocation()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//
//    }
//
//    // MARK: - Setup View
//    private func setupView() {
//        view.backgroundColor = .systemBackground
//        setupMapView()
//    }
//
//    private func setupMapView() {
//        view.addSubview(mapView)
//        mapView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    // MARK: - Private Methods
//
//    private func render(_ location: CLLocation) {
//
//        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                                longitude: location.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region  = MKCoordinateRegion(center: coordinate, span: span)
//
//        mapView.setRegion(region,
//                          animated: true)
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        mapView.addAnnotation(pin)
//    }
//}
//
//extension MapTestViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            locationManager.stopUpdatingLocation()
//
//            render(location)
//        }
//    }
//}
//
//
////class MapTestViewController: UIViewController {
////
////    private let mapView = MKMapView()
////
////    private var locationManager = CLLocationManager()
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        setupView()
////        setupLocationManager()
////        locationManager.startUpdatingLocation()
////        locationManager.requestLocation()
////    }
////
////    // MARK: - Private methods
////    private func setupView() {
////        view.backgroundColor = .systemBackground
////        setupMapView()
////    }
////
////    private func setupMapView() {
////        view.addSubview(mapView)
////        mapView.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
////    }
////
////    private func setupLocationManager() {
////        DispatchQueue.global().async { [weak self] in
////            guard let self = self else { return }
////            if CLLocationManager.locationServicesEnabled() {
////                self.locationManager.delegate = self
////                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
////                self.handleAutorizationStatus(locationManager: self.locationManager, status: locationManager.authorizationStatus)
////            } else {
////                print("Location services are not enables")
////            }
////        }
////    }
////
////    private func handleAutorizationStatus(locationManager: CLLocationManager, status: CLAuthorizationStatus) {
////
////        switch status {
////        case .notDetermined:
////            locationManager.requestWhenInUseAuthorization()
////        case .restricted:
////            // TODO: - Make alert
////            break
////        case .denied:
////            // TODO: - Make alert
////            break
////        case .authorizedAlways:
////            break
////        case .authorizedWhenInUse:
////            break
////        case .authorized:
////            break
////        @unknown default:
////            break
////        }
////    }
////}
////
////extension MapTestViewController: CLLocationManagerDelegate {
////    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        if let location = locations.first {
////            locationManager.stopUpdatingLocation()
//////            render(location)
////        }
////    }
////}
