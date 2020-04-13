//
//  DBManager.swift
//  Deadliner
//
//  Created by Muhammad Nobel Shidqi on 07/04/20.
//  Copyright © 2020 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation
import CoreData


enum Operation {
    case add,update
}

struct DBManager {
    
    let context = AppDelegate.singleton.persistentContainer.viewContext
    
    mutating func fetch(withPredicate predicate: NSPredicate? = nil) -> [Activity]{
        let request: NSFetchRequest<Activity> = NSFetchRequest(entityName: DBK.activityEntityName)
        var results: [Activity] = []
        request.predicate = predicate
        
        do {
            results = try context.fetch(request)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    
        return results
    }
    
    private func saveToDB() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func save(object: Activity, operation: Operation) {
        switch operation {
        case .add:
            Notification.addNotification(object)
        case .update:
            Notification.editNotification(object)
        }
        
        saveToDB()
    }
    
    
    func remove(_ object: NSManagedObject) {
        Notification.removeNotification(object as! Activity)
        context.delete(object)
        saveToDB()
    }
    
}
