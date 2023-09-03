import Foundation
import UIKit
import SnapKit

protocol HomeControllerDelegate: AnyObject {
    var viewController: HomeControllerInterface? { get set }
    
    func willShowProfileController()
    func willShowCartController()
    
    func willShowCoffeeProducts()
    func willShowUsername()
    func willShowDetailController(for coffeeProduct: CoffeeProduct)
    func willShowCountLabel()
}

protocol HomeControllerInterface: AnyObject {
    func pushProfileController(user: DDUser)
    func pushCartController()
    func showAlert(_ alertController: UIAlertController)
    
    func presentCoffeeProducts(products: [CoffeeProduct])
    func presentUsername(_ username: String)
    func pushDetailController(for coffeeProduct: CoffeeProduct)
    func updateCartCountLabel(isHidden: Bool, count: Int)
}

class HomeController: UIViewController {
    
    var delegate: HomeControllerDelegate?
    private var homeView: HomeView?
    
    init(delegate: HomeControllerDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.viewController = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        delegate?.willShowUsername()
        delegate?.willShowCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print("HomeViewController is dead")
    }
    
    // MARK: - Setup View
    private func setupView() {
        setupNavBar()
        homeView = HomeView(delegate: self)
        guard let homeView = homeView else { return }
        
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        homeView.delegate = self
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = AppColors.NavController.darkBlue
    }
}

// MARK: - HomeViewDelegate
extension HomeController: HomeViewDelegate {
    func willShowUsername() {
        delegate?.willShowUsername()
    }
    
    func didTappedCartButton() {
        delegate?.willShowCartController()
    }
    
    func didTappedProfileButton() {
        delegate?.willShowProfileController()
    }
    
    func willShowCoffeeProducts() {
        delegate?.willShowCoffeeProducts()
    }
    
    func didlSelectCoffeeProduct(_ coffeeProduct: CoffeeProduct) {
        delegate?.willShowDetailController(for: coffeeProduct)
    }
    
    func willShowCartCountLabel() {
        delegate?.willShowCountLabel()
    }
}

// MARK: - HomeControllerInterface
extension HomeController: HomeControllerInterface {
    func presentCoffeeProducts(products: [CoffeeProduct]) {
        homeView?.presentProducts(products)
    }
    
    func pushCartController() {
        let myCartController = MyCartModuleAssembly.configureMoule()
        myCartController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myCartController, animated: true)
    }
    
    func pushProfileController(user: DDUser) {
        let profileViewController = UserProfileModuleAssembly.configureModule(user: user)
        profileViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func showAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func pushDetailController(for coffeeProduct: CoffeeProduct) {
        let detailsController = DetailModuleAssembly.configureModule(coffeeProduct)
        detailsController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailsController, animated: true)
    }
    
    func presentUsername(_ username: String) {
        homeView?.presentUsername(username)
    }
    
    func updateCartCountLabel(isHidden: Bool, count: Int) {
        homeView?.updateCartLabelCount(isHidden: isHidden, count: count)
    }
}
