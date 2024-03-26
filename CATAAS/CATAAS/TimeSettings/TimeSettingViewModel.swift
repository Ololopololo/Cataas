import Foundation
import WACore

class TimeSettingViewModel: AppParameters {
    
    private let notifications: Notifications
    
    var showAlert: (() -> Void)?

    init(notifications: Notifications = Notifications()) {
        self.notifications = notifications
    }
    
    var timeOne: Date {
        get { params.get(AppKeys.timeOne, type: Date.self).value ?? Date() }
        set { params.set(AppKeys.timeOne, value: newValue) }
    }
    
    var timeTwo: Date {
        get { params.get(AppKeys.timeTwo, type: Date.self).value ?? Date() }
        set { params.set(AppKeys.timeTwo, value: newValue) }
    }
    
    func saveTimeSettings() {
        if (params.get(AppKeys.enabledNotifications, type: Bool.self).value ?? false) {
            notifications.dispatchNotification(at: timeOne, withIdentifier: "timeOneNotification") { success in
                print(success ? "Notification for timeOne Set" : "Notification for timeOne not working")
            }
            notifications.dispatchNotification(at: timeTwo, withIdentifier: "timeTwoNotification") { success in
                print(success ? "Notification for timeTwo Set" : "Notification for timeTwo not working")
            }
        } else {
            print("ShowAlert")
            DispatchQueue.main.async { [weak self] in
                self?.params.reset(AppKeys.timeOne)
                self?.params.reset(AppKeys.timeTwo)
                self?.showAlert?()
            }
        }
    }
    
    func requestNotificationPermissions(completion: @escaping (Bool) -> Void) {
        notifications.requestPermissions { [weak self] allowed in
            DispatchQueue.main.async {
                self?.params.set(AppKeys.enabledNotifications, value: allowed)
                completion(allowed)
            }
        }
    }
}

