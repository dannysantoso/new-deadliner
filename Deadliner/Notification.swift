import Foundation
import UIKit
import CoreData
import UserNotifications

class Notification:NSObject, UNUserNotificationCenterDelegate {
    
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    let notificationCenter = UNUserNotificationCenter.current()
    static var instance:Notification?
    private let REMINDER_TIME = TimeInterval(900)
    
    
    enum notifIdentifier: String{
        case cmo = "CMO"
        case end = "END"
    }
    
    static func getInstance() -> Notification {
        if let fetchInstance = instance{
            return fetchInstance
        } else {
            instance = Notification()
            return instance!
        }
    }
    
    func notificationConfig() {
        requestNotificationAuth()
        removeBadge()
    }
    
    func requestNotificationAuth() {
        notificationCenter.requestAuthorization(options: self.options) {
            (didAllow, error) in
            if !didAllow{
                print("User Decline")
            }
        }
    }
    
    func checkNotificationAuth(){
        notificationCenter.getNotificationSettings { (setting) in
            if setting.authorizationStatus != .authorized {
                
            }
        }
        
    }
    
    func removeBadge() {
        let currentNotif =  UIApplication.shared.applicationIconBadgeNumber
        let badgeCounter = UserDefaults.standard.integer(forKey: "badge") - currentNotif
        UserDefaults.standard.set(
            badgeCounter < 0
                ? 0
                : badgeCounter,
            forKey: "badge")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    private func buildNotification(_ activity:Activity, identifier:notifIdentifier ) {
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
        content.userInfo["activity"] = activity.id!
        content.userInfo["title"] = activity.title!
        content.userInfo["startDate"] = dateConverter(tanggal: (activity.startDate)!)
        content.userInfo["endDate"] = dateConverter(tanggal: (activity.endDate)!)
        content.userInfo["priority"] = activity.priority
        UserDefaults.standard.set(badge, forKey: "badge")
        let timeInterval =
            identifier == .cmo
                ? activity.startDate!.timeIntervalSinceNow
                : activity.endDate!.timeIntervalSinceNow
        if timeInterval >= 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(
                identifier: "\(identifier.rawValue)\(activity.id!)",
                content: content,
                trigger: trigger)
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }


    static func addNotification(_ activity:Activity) {
        let notification = Notification.getInstance()
        notification.buildNotification(activity, identifier: .cmo)
        notification.buildNotification(activity, identifier: .end)
    }

    static func editNotification(_ activity:Activity) {
        print(activity.objectID)
        addNotification(activity)
    }

    static func removeNotification(_ activity:Activity) {
        Notification.getInstance().notificationCenter.removePendingNotificationRequests(withIdentifiers: ["CMO\(activity.id!)","END\(activity.id!)"])
    }

    private func configureNotifAction(identifier:notifIdentifier) -> String {
        let remindAction = UNNotificationAction(identifier: "Remind", title: "Remind Again", options: [])
//        let markAsDoneAction = UNNotificationAction(identifier: "Mark", title: "Mark As done", options: [])
        
        let categoryEnd = UNNotificationCategory(identifier: "DeadlinerNotificationsEND",
        actions: [remindAction],
        intentIdentifiers: [],
        options: [])
        let categoryCmo = UNNotificationCategory(identifier: "DeadlinerNotificationsCMO",
        actions: [remindAction],
        intentIdentifiers: [],
        options: [])
        self.notificationCenter.setNotificationCategories([categoryEnd,categoryCmo])
        
        switch identifier {
            case .end :
                return categoryEnd.identifier
            case .cmo :
                return categoryCmo.identifier
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        removeBadge()
        completionHandler(UNNotificationPresentationOptions.init([.alert, .badge]))
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notificationRequest = response.notification.request
        switch response.actionIdentifier {
        case "Remind":
            rescheduleNotification(notificationRequest, center)
        case "Mark":
            markActivityAsDone(notificationRequest)
        default:
            print("error")
        }
    }
    
    private func rescheduleNotification(_ notificationRequest:UNNotificationRequest, _ center: UNUserNotificationCenter) {
        let content = notificationRequest.content
        let identifier = notificationRequest.identifier
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: self.REMINDER_TIME,
            repeats: false)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    private func markActivityAsDone(_ notificationRequest:UNNotificationRequest) {
//        let activityId = notificationRequest.content.userInfo["activity"] as! String
//        var db = DBManager()
//        let predicate = NSPredicate(format: "id == %@",activityId)
//        let activity = db.fetch(withPredicate: predicate)[0]
//        activity.isDone = true
//        db.save(object: activity, operation: .update)
    }
    
}


