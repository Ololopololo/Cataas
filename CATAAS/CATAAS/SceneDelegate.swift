import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        UNUserNotificationCenter.current().delegate = self
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        showMainScreen()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    func showMainScreen() {
        setRootViewController(MainTabBarController())
        
        let notifications = Notifications()
        let defaults = UserDefaults.standard
        
        print("Asked \(defaults.bool(forKey: "notificationsAsked"))")
        print("Enabled \(defaults.bool(forKey: "notificationsEnabled"))")
        
        if !defaults.bool(forKey: "notificationsAsked") {
            notifications.requestPermissions { allowed in
                if allowed {
                    defaults.set(true, forKey: "notificationsAsked")
                    print("Asked \(defaults.bool(forKey: "notificationsAsked"))")
                    print("Enabled \(defaults.bool(forKey: "notificationsEnabled"))")
                }
            }
        }
    }
    
    
}

extension SceneDelegate {
    private func setRootViewController(_ vc: UIViewController) {
        guard let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    internal func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        let catHistoryViewModel = CatHistoryViewModel()
            catHistoryViewModel.fetchCatImage { success, error in
                print("fetched")
            }
        }
        completionHandler()
    }
}
