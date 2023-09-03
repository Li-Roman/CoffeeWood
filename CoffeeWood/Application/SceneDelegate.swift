import UIKit

let screenSize: CGRect = UIScreen.main.bounds

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        if let _ = AuthService.shared.currentUser {
            let tabbarController = GeneralTabBatController()
            window?.rootViewController = tabbarController
        } else {
            let viewController = OnboardingModuleAssembly.configureModule()
            let navController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navController
        }

        window?.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ viewController: UIViewController, animation: Bool = true) {
        guard let window = self.window else { return }
        
        // change the root view controller to your specific view controller
        window.rootViewController = viewController
        UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations: nil,
                              completion: nil)
    }
}

