import Foundation

class TimeSettingViewModel {
    
    private let notifications: Notifications
    private let defaults = UserDefaults.standard
    
    var showAlert: (() -> Void)?

    init(notifications: Notifications = Notifications()) {
        self.notifications = notifications
    }
    
    var timeOne: Date {
        get { defaults.object(forKey: "timeOne") as? Date ?? Date() }
        set { defaults.set(newValue, forKey: "timeOne") }
    }
    
    var timeTwo: Date {
        get { defaults.object(forKey: "timeTwo") as? Date ?? Date() }
        set { defaults.set(newValue, forKey: "timeTwo") }
    }
    
    func saveTimeSettings() {
        if defaults.bool(forKey: "notificationsEnabled") {
            notifications.dispatchNotification(at: timeOne, withIdentifier: "timeOneNotification") { success in
                print(success ? "Notification for timeOne Set" : "Notification for timeOne not working")
            }
            notifications.dispatchNotification(at: timeTwo, withIdentifier: "timeTwoNotification") { success in
                print(success ? "Notification for timeTwo Set" : "Notification for timeTwo not working")
            }
        } else {
            print("ShowAlert")
            DispatchQueue.main.async { [weak self] in
                self?.defaults.removeObject(forKey: "timeOne")
                self?.defaults.removeObject(forKey: "timeTwo")
                self?.showAlert?()
            }
        }
    }
    
    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        notifications.requestPermissions { [weak self] allowed in
            DispatchQueue.main.async {
                self?.defaults.set(allowed, forKey: "notificationsEnabled")
                completion(allowed)
            }
        }
    }
}

