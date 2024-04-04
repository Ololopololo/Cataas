import UIKit
import UserNotifications
import WACore


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
        let notifications = Notifications()

        setRootViewController(UINavigationController(rootViewController: MainTabBarController()))

        print("Asked \(params.get(AppKeys.enabledNotifications, type: Bool.self).value ?? false)")
        print("Enabled \(params.get(AppKeys.enabledNotifications, type: Bool.self).value ?? false)")
        
        if !(params.get(AppKeys.enabledNotifications, type: Bool.self).value ?? false)
        {
            notifications.requestPermissions { [self] allowed in
                if allowed {
                    self.params.set(AppKeys.askedNotifications, value: true)
                    print("Asked \(params.get(AppKeys.askedNotifications, type: Bool.self).value ?? false)")
                    print("Enabled \(params.get(AppKeys.enabledNotifications, type: Bool.self).value ?? false)")
                }
            }
        }
    }
    
    
}

extension SceneDelegate: AppParameters {
    private func setRootViewController(_ vc: UIViewController) {
        guard let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let catHistoryViewModel = CatHistoryViewModel()
            catHistoryViewModel.fetchCatImageAlamoFire { success, error in
                if success {
                    NotificationCenter.default.post(name: .catHistoryShouldRefresh, object: nil)
                }
            }
        
        self.params.set(AppKeys.shouldShowCat, value: true)
        completionHandler()
    }
}
