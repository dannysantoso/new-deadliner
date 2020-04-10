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
        switch identifier {
            case .cmo:
                content.title = "Coming Up"
                content.body = "\(activity.title!) is going to start soon"
            case .end:
                content.title = "Deadline"
                content.body = "\(activity.title!) is going to due soon"
        }
        content.sound = .default
        let badge = UserDefaults.standard.integer(forKey: "badge") + 1
        content.badge = NSNumber(value: badge)
        UserDefaults.standard.set(badge, forKey: "badge")
        content.categoryIdentifier = "DeadlinerNotification"
        let timeInterval =
            identifier == .cmo
                ? activity.startDate!.timeIntervalSinceNow
                : activity.endDate!.timeIntervalSinceNow
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
    static func configureNotifAction() {
        let openApps = UNNotificationAction(identifier: "Open", title: "Open In Apps", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: "DeadlinerNotifications", actions: [openApps, deleteAction], intentIdentifiers: [], options: [])
        self.notificationCenter.setNotificationCategories([category])
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
            case "Open":
                print("Open")
            case "Delete":
                print("Delete")
            default:
                print("Not Both")
        }
        completionHandler()
    }
    
}
