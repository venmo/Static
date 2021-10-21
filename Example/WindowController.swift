import UIKit

@UIApplicationMain final class WindowController: UIResponder {
    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: ViewController())
        return window
    }()
}


extension WindowController: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()
        return true
    }
}
