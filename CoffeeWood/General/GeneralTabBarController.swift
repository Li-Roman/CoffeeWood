import Foundation
import UIKit

enum GeneralTabs: Int {
    case homeSection
    case mapSection
    case orderSection
}

final class GeneralTabBatController: UITabBarController {
    
    deinit {
        print("GeneralTabBatController is dead")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setupNavBarControllers()
        
        tabBar.tintColor = AppColors.Buttons.Back.blue
        tabBar.barTintColor = AppColors.Buttons.Icon.whiteIcon
        
        let positionOnX: CGFloat = 24
        let positionOnY: CGFloat = 12
        let width = tabBar.bounds.width - positionOnX * 2
        let height: CGFloat = 70
        
        let roundLayer = CAShapeLayer()
        
        let bazierPath = UIBezierPath(
            roundedRect: CGRect(x: positionOnX,
                                y: -positionOnY,
                                width: width,
                                height: height
            ),
            cornerRadius: 22
        )
        
        roundLayer.path = bazierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 18
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBar.layer.shadowRadius = 14
        tabBar.layer.shadowOpacity = 0.15
        
        roundLayer.fillColor = AppColors.Background.whiteBack.cgColor
    }
    
    private func setupNavBarControllers() {
        let homeController = HomeModuleAssembly.configureModule()
        let homNavController = UINavigationController(rootViewController: homeController)
        
        let mapController = MapModuleAssembly.configureModule()
        let mapNavigationController = UINavigationController(rootViewController: mapController)
        
        let orderController = MyOrdersModuleAssembly.configureModule()
        let orderNavigationController = UINavigationController(rootViewController: orderController)
        
        homNavController.tabBarItem = UITabBarItem(title: nil,
                                                 image: Resources.Images.TabBar.homeSection,
                                                 tag: GeneralTabs.homeSection.rawValue)
        mapNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                 image: Resources.Images.TabBar.rewardSection,
                                                          tag: GeneralTabs.mapSection.rawValue)
        orderNavigationController.tabBarItem = UITabBarItem(title: nil,
                                                 image: Resources.Images.TabBar.orderSection,
                                                 tag: GeneralTabs.orderSection.rawValue)
        setViewControllers([
            homNavController,
            mapNavigationController,
            orderNavigationController
        ], animated: false)
    }
}
