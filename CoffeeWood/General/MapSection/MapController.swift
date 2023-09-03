import Foundation
import UIKit
import SnapKit
import MapKit

enum ReplaceDirection {
    case up
    case down
}

protocol MapControllerDelegate: AnyObject {
    var viewConrtoller: MapControllerInterface? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func willCenterUserLocation()
    func didSelectAnnotation(annotation: CoffeeHouseAnnotation)
    func didDeselectAnnotation(annotation: CoffeeHouseAnnotation)
    func didFinishObtainCoffeeHouses()
}

protocol MapControllerInterface: AnyObject {
    func showAlert(_ alertController: UIAlertController)
    func showCoffeeHouses(_ locations: [CoffeeHouseAnnotation])
    func centerInRegion(_ region: MKCoordinateRegion)
    func presentVC(viewController: UIViewController)
    func deselectAnnotation(annotation: CoffeeHouseAnnotation?)
    func selectAnnotation(annotation: CoffeeHouseAnnotation)
    func turnOnUserLocation()
    func replaceCurrentLocationButtonUp(to: ReplaceDirection)
}

class MapController: UIViewController {
    
    var delegate: MapControllerDelegate?
    
    private let currentLocationButton = UIButton()
    private let mapView = MKMapView()
    
    init(delegate: MapControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.viewConrtoller = self
        delegate?.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.viewWillAppear()
    }
}

// MARK: - Setup View
extension MapController {
    private func setupView() {
        setupMapView()
        setupCurrentLocationButton()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let zoomRage = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 40000)
        mapView.setCameraZoomRange(zoomRage, animated: true)
    }
    
    private func setupCurrentLocationButton() {
        view.addSubview(currentLocationButton)
        
        let positionX = screenSize.width - 60
        let positionY = screenSize.height - 145
        self.currentLocationButton.frame = CGRect(x: positionX, y: positionY, width: 30, height: 30)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(named: "targetLocation")?.withConfiguration(config)
        
        currentLocationButton.configuration = .borderless()
        currentLocationButton.configuration?.image = image
        currentLocationButton.configuration?.baseForegroundColor = .systemRed
        currentLocationButton.configuration?.baseBackgroundColor = .systemRed
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonAction(sender:)), for: .touchUpInside)
    }
    
    @objc private func currentLocationButtonAction(sender: UIButton) {
        delegate?.willCenterUserLocation()
    }
}

// MARK: - TestMapControllerInterface
extension MapController: MapControllerInterface {
    func turnOnUserLocation() {
        DispatchQueue.main.async {
            self.mapView.showsUserLocation = true
        }
    }
    
    func showAlert(_ alertController: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    func showCoffeeHouses(_ locations: [CoffeeHouseAnnotation]) {
        DispatchQueue.main.async {
            locations.forEach { [weak self] location in
                self?.mapView.addAnnotation(location)
            }
        }
        delegate?.didFinishObtainCoffeeHouses()
    }
    
    func centerInRegion(_ region: MKCoordinateRegion) {
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func presentVC(viewController: UIViewController) {
        DispatchQueue.main.async {
            self.present(viewController, animated: true)
        }
    }
    
    func deselectAnnotation(annotation: CoffeeHouseAnnotation?) {
        DispatchQueue.main.async {
            self.mapView.deselectAnnotation(annotation, animated: true)
        }
    }
    
    func selectAnnotation(annotation: CoffeeHouseAnnotation) {
        DispatchQueue.main.async {
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func replaceCurrentLocationButtonUp(to: ReplaceDirection) {
        switch to {
        case .up:
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.27) {
                    let positionX = screenSize.width - 60
                    let positionY = screenSize.height - 365
                    self.currentLocationButton.frame = CGRect(x: positionX, y: positionY, width: 30, height: 30)
                    self.view.layoutIfNeeded()
                }
            }
        case .down:
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.27) {
                    let positionX = screenSize.width - 60
                    let positionY = screenSize.height - 145
                    self.currentLocationButton.frame = CGRect(x: positionX, y: positionY, width: 30, height: 30)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: - MapViewDelegate
extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CoffeeHouse"
        
        guard let annotation = annotation as? CoffeeHouseAnnotation else {
            return nil
        }

        var view: MKAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        view.image = annotation.isActiveOrder == false ? UIImage(named: "annotationTag")! : UIImage(named: "ActiveOrderAnnotation")!

        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let annotation = annotation as? CoffeeHouseAnnotation else {
            return
        }
        delegate?.didSelectAnnotation(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        guard let annotation = annotation as? CoffeeHouseAnnotation else {
            return
        }
        
        delegate?.didDeselectAnnotation(annotation: annotation)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.image == UIImage(named: "annotationTag") {
            view.image = UIImage(named: "chosenAnnotationTag")
        }

        if view.image == UIImage(named: "ActiveOrderAnnotation") {
            view.image = UIImage(named: "chosenActiveOrderAnnotation")
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.image == UIImage(named: "chosenAnnotationTag") {
            view.image = UIImage(named: "annotationTag")
        }

        if view.image == UIImage(named: "chosenActiveOrderAnnotation") {
            view.image = UIImage(named: "ActiveOrderAnnotation")
        }
    }
}

