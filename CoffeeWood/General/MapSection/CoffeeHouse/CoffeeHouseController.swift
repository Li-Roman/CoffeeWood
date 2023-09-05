import Foundation
import UIKit
import SnapKit

protocol CoffeeHouseControllerDelegate: AnyObject {
    var coffeeHouseController: CoffeeHouseControllerInterface? { get set }
    func willDeinitCoffeeHouseController()
}

protocol CoffeeHouseControllerInterface: AnyObject {
    func dismiss()
    func setupView(with coffeeHouse: CoffeeHouseAnnotation, activeOrder: Order?)
}

class CoffeeHouseController: UIViewController {
    
    weak var delegate: CoffeeHouseControllerDelegate?
    
    private let activeOrder: Order?
    
    private var orderStatusView: OrderStatusView?
    private let coffeeHouseIconView = UIImageView()
    private let coffeeHouseNameLabel = UILabel()
    private let coffeeHouseAddressLabel = UILabel()
    private let callButton = UIButton()
    private let routeButton = UIButton()
    private let grabberView = UIView()
    
    init(delegate: CoffeeHouseControllerDelegate, activeOrder: Order?) {
        self.delegate = delegate
        self.activeOrder = activeOrder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        print("CoffeeHouseController is dead")
        delegate?.willDeinitCoffeeHouseController()
    }
}

// MARK: - Setup View
extension CoffeeHouseController {
    private func setupView() {
        delegate?.coffeeHouseController = self
        view.backgroundColor = AppColors.Background.blueBack

        setupOrderStatusView()
        setupCoffeeHouseIconView()
        setupCoffeeHouseNameLabel()
        setupCoffeeAddressLabel()
        setupRouteButton()
        setupCallButton()
        setupGrabberView()
    }
    
    private func setupOrderStatusView() {
        orderStatusView = OrderStatusView(activeOrder: self.activeOrder)
        
        view.addSubview(orderStatusView!)
        orderStatusView!.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(-30)
            make.top.equalToSuperview().inset(82)
        }
        
        orderStatusView!.layer.cornerRadius = 30
        orderStatusView!.clipsToBounds = true
    }
    
    private func setupCoffeeHouseIconView() {
        view.addSubview(coffeeHouseIconView)
        coffeeHouseIconView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(18)
            make.height.width.equalTo(46)
        }
        
        coffeeHouseIconView.backgroundColor = AppColors.Background.grayBack
        coffeeHouseIconView.image = Resources.Images.CoffeeHouseController.coffeeHouseIcon
        coffeeHouseIconView.contentMode = .scaleAspectFit
        coffeeHouseIconView.layer.cornerRadius = 23
        coffeeHouseIconView.clipsToBounds = true
    }
    
    private func setupCoffeeHouseNameLabel() {
        coffeeHouseNameLabel.font = Resources.Font.CoffeeHouseController.mainLabel
        coffeeHouseNameLabel.textAlignment = .left
        coffeeHouseNameLabel.textColor = .white
        
        view.addSubview(coffeeHouseNameLabel)
        coffeeHouseNameLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeHouseIconView)
            make.left.equalTo(coffeeHouseIconView.snp_rightMargin).inset(-20)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
    }
    
    private func setupCoffeeAddressLabel() {
        coffeeHouseAddressLabel.font = Resources.Font.CoffeeHouseController.addressLabel
        coffeeHouseAddressLabel.textAlignment = .left
        coffeeHouseAddressLabel.textColor = AppColors.Labels.warmGray
        
        view.addSubview(coffeeHouseAddressLabel)
        coffeeHouseAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeHouseNameLabel.snp_bottomMargin).inset(-14)
            make.left.equalTo(coffeeHouseNameLabel)
            make.height.equalTo(16)
            make.width.equalTo(200)
        }
    }
    
    private func setupRouteButton() {
        routeButton.configuration = .filled()
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        routeButton.configuration?.image = Resources.Images.CoffeeHouseController.routeButton?.withConfiguration(config)
        routeButton.configuration?.cornerStyle = .capsule
        routeButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.lightBlue
        
        view.addSubview(routeButton)
        routeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(21)
            make.top.equalToSuperview().inset(21)
            make.width.height.equalTo(40)
        }
    }
    
    private func setupCallButton() {
        callButton.configuration = .filled()
        callButton.configuration?.image = Resources.Images.CoffeeHouseController.callButton
        callButton.configuration?.cornerStyle = .capsule
        callButton.configuration?.baseBackgroundColor = AppColors.Buttons.Back.lightBlue
        
        view.addSubview(callButton)
        callButton.snp.makeConstraints { make in
            make.centerY.equalTo(routeButton)
            make.right.equalTo(routeButton.snp_leftMargin).inset(-20)
            make.width.height.equalTo(40)
        }
    }
    
    private func setupGrabberView() {
        view.addSubview(grabberView)
        grabberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(4)
            make.width.equalTo(30)
            make.height.equalTo(4)
        }
        
        grabberView.backgroundColor = AppColors.Lines.gray
        grabberView.layer.cornerRadius = 2
    }
}

// MARK: - CoffeeHouseControllerInterface
extension CoffeeHouseController: CoffeeHouseControllerInterface {
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func setupView(with coffeeHouse: CoffeeHouseAnnotation, activeOrder: Order?) {
        self.coffeeHouseNameLabel.text = coffeeHouse.title
        self.coffeeHouseAddressLabel.text = coffeeHouse.address
        orderStatusView?.updateView(activeOrder: activeOrder)
    }
}
