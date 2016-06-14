import UIKit

@UIApplicationMain final class WindowController: UIResponder {
    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main().bounds)
        window.rootViewController = UINavigationController(rootViewController: ViewController())
        return window
    }()
}


extension WindowController: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.makeKeyAndVisible()
        return true
    }
}
