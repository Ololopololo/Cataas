import Foundation
import UserNotifications
import WACore

class Notifications: AppParameters {
    let notificationCenter = UNUserNotificationCenter.current()

    func requestPermissions(completion: @escaping (Bool) -> Void) {
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { allowed, _ in
                    if allowed {
                        self.setNotificationsEnabled(true)
                    }
                    completion(allowed)
                }
            case .denied:
                completion(false)
            case .authorized:
                self.setNotificationsEnabled(true)
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    private func setNotificationsEnabled(_ enabled: Bool) {
        params.set(AppKeys.enabledNotifications, value: enabled)
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
    }
    
    func dispatchNotification(at date: Date, withIdentifier identifier: String, completion: ((Bool) -> Void)? = nil) {
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Время котика!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Пора проверить нового котика!", arguments: nil)
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Ошибка при добавлении уведомления: \(error)")
                completion?(false)
            } else {
                completion?(true)
            }
        }
    }
    
    func disableNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        setNotificationsEnabled(false)
    }
    
}
