

Initialization

    var db = DBManager()
    
------------------------------------------------------------------------------------------------------------

Create Data

    db.save()
    
    ex :
        let activities: [Activity] = []
    
        let newActivity = Activity(context: db.context)
        newActivity.title = "activity 1"
        newActivity.priority = 0
        .
        .
        .
        db.save()
        activities.append(newActivity)
        tableView.reloadData()

------------------------------------------------------------------------------------------------------------

Get Data
    
    a) All
        db.fetch()  | return type [Activity]
        
        ex :

            let activities = db.fetch()
            
            ga perlu kaya tadi, ini lebih singkat, langsung aja activities bisa dipake utk data di table view
            
    b) Filter
        db.fetch(withPredicate: <#T##NSPredicate?#>) | return type [Activity]
        
        ex :
            let searchForTitle = "Apple"
            let predicate = NSPredicate(format: "title MATCHES[cd] %@", searchForTitle)
            let activites = db.fetch(withPredicate: predicate)
            
            sama kayak fetch biasa, fungsi hasil return db.fetch bisa dipake langsung ke table view
    
    
------------------------------------------------------------------------------------------------------------
    
Remove Data
    
    db.remove(<#T##object: NSManagedObject##NSManagedObject#>)
    
    ex:
    
    let activityWillRemove = activities[index]
    db.remove(activityWillRemove)
    activities.remove(at: index)
    tableView.reloadData()
    
------------------------------------------------------------------------------------------------------------

Update Data
    
    ex :
    
        let selectedActivity = activities[index]
        selectedActivity.title = "new title"
        
        db.save()
        tableView.reloadData()
        

    
        
