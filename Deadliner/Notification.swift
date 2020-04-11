import Foundation
import UIKit
import UserNotifications

class Notification:NSObject, UNUserNotificationCenterDelegate{
    
    static var notificationCenter:UNUserNotificationCenter = UNUserNotificationCenter.current()
    static var options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    enum notifIdentifier: String{
        case cmo = "CMO"
        case end = "END"
    }
    
    static func requestNotificationAuth() {
        notificationCenter.requestAuthorization(options: self.options) {
            (didAllow, error) in
            if !didAllow{
                print("User Decline")
            }
        }
    }
    
    static func checkNotificationAuth(){
        notificationCenter.getNotificationSettings { (setting) in
            if setting.authorizationStatus != .authorized {
                
            }
        }
        
    }
    
    static func removeBadge() {
        let currentNotif =  UIApplication.shared.applicationIconBadgeNumber
        let badgeCounter = UserDefaults.standard.integer(forKey: "badge") - currentNotif
        UserDefaults.standard.set(
            badgeCounter < 0
                ? 0
                : badgeCounter,
            forKey: "badge")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    static private func buildNotification(_ activity:Activity, identifier:notifIdentifier ) {
        let content = UNMutableNotificationContent()
        let badge = UserDefaults.standard.integer(forKey: "badge") + 1
        switch identifier {
        case .cmo:
            content.body = "was going to start soon"
        case .end:
            content.body = "was going to due soon"
        }
        content.title = activity.title!
        content.sound = .default
        content.badge = NSNumber(value: badge)
        content.categoryIdentifier = configureNotifAction(identifier: identifier)
        UserDefaults.standard.set(badge, forKey: "badge")
        let timeInterval =
            identifier == .cmo
                ? activity.startDate!.timeIntervalSinceNow
                : activity.endDate!.timeIntervalSinceNow
        if timeInterval >= 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(identifier.rawValue)\(activity.objectID)",
                content: content,
                trigger: trigger)
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    
    static func addNotification(_ activity:Activity) {
        buildNotification(activity, identifier: .cmo)
        buildNotification(activity, identifier: .end)
    }
    
    static func editNotification(_ activity:Activity) {
        addNotification(activity)
    }
    
    static func removeNotification(_ activity:Activity) {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: ["CMO\(activity.objectID)","END\(activity.objectID)"])
    }
    
    // Configuring Action (Button) for notification
    private static func configureNotifAction(identifier:notifIdentifier) -> String {
        let remindAction = UNNotificationAction(identifier: "Remind", title: "Remind in 1 day", options: [])
        let markAsDoneAction = UNNotificationAction(identifier: "Mark", title: "Mark As done", options: [])
        var category:UNNotificationCategory
        switch identifier {
            case .end:
                category = UNNotificationCategory(identifier: "DeadlinerNotificationsEND",
                actions: [remindAction, markAsDoneAction],
                intentIdentifiers: [],
                options: [])
            default:
                category = UNNotificationCategory(identifier: "DeadlinerNotificationsCMO",
                actions: [remindAction],
                intentIdentifiers: [],
                options: [])
        }
        self.notificationCenter.setNotificationCategories([category])
        return category.identifier
    }
    
    // Delegation Respond to Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Remind":
            print("Open")
        case "Mark":
            print("Delete")
        default:
            print("Not Both")
        }
        completionHandler()
    }
    
}
